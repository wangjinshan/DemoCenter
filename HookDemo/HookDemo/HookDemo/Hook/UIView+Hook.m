//
//  UIView+Hook.m
//  blackboard
//
//  Created by roni on 2018/12/18.
//  Copyright © 2018 xkb. All rights reserved.
//

#import "UIView+Hook.h"
#import "RuntimeHelper.h"
//#import "blackboard-Swift.h"
//#import <XHBMars/Mars.h>
#import "UIGestureRecognizer+Hook.h"
//#import <JRE/JRE.h>

@implementation UIView (Hook)

static NSString *const kLastActionTime = @"kLastActionTime";

static NSArray * blacklist;
static NSArray * viewBlackList;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blacklist = [ @"UIPredictionViewController UIAlertController IInputWindowController UISystemInputAssistantViewController UICandidateViewController UICompatibilityInputViewController" componentsSeparatedByString: @" "];
        viewBlackList = [[NSArray alloc] initWithObjects:@"UISwitchModernVisualElement", nil];
        SEL originalSel = @selector(addGestureRecognizer:);
        SEL swizzledSEL = @selector(hook_addGestureRecognizer:);
        Class class = [UIView class];
        if ([self isContainSel:originalSel inClass:class]) {
            [self sel_exchangeFromSel:originalSel toSel:swizzledSEL];
        }
    });
}

- (UIImage *)viewSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (BOOL)isInBlackList: (NSString *)controlName
{
    NSArray * list = [controlName componentsSeparatedByString: @"#"];
    for (id n in list) {
        if ([blacklist containsObject: n]) {
            return true;
        }
    }
    return false;
}

- (BOOL)isViewInBlackList:(UIView *)view {
    return [viewBlackList containsObject:[PathHelper getClassNameWithSender:view]];
}

- (void)hook_addGestureRecognizer:(UIGestureRecognizer *)gesture {
    [self hook_addGestureRecognizer:gesture];
    
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]] || [gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [gesture addTarget:self action:@selector(autoEventAction:)];
    }
}

- (void)autoEventAction:(UIGestureRecognizer *)gesture {

    if ([viewBlackList containsObject:[PathHelper getClassNameWithSender:gesture.view]]) {
        return;
    }

    NSDictionary *component = [PathHelper getViewDesc:gesture.view];
    NSString *componentName = [component valueForKey:@"componentName"];
    NSString *componentTitle = [component valueForKey:@"componentTitle"];
    NSString *subComponent = [component valueForKey:@"subComponent"];
    
    NSString *title = [PathHelper getTitleWithSender:gesture.view];
    NSString *key = @"";

    if (gesture.uniqueId != nil && ![gesture.uniqueId isEqualToString:@""]) {
        key = gesture.uniqueId;
    } else if (gesture.view.uniqueId) {
        key = gesture.view.uniqueId;
    }
    
    OrgJsonJSONObject *params = nil;
    if (gesture.view.traceParams) {
        params = [OrgJsonJSONObject dicToJSONObject:gesture.view.traceParams];
    }
    
    NSString * path = [self getViewPath];
    
    NSLog(@"UIView+Hook: componentName: %@ subComponent: %@ path: %@", componentName, subComponent, path);

    [SLMarsIO addClickWithNSString:componentName
                      withNSString:subComponent
                      withNSString:componentTitle
                      withNSString:path
                      withNSString:title
                      withNSString:key
              withSLJsonObjectAble:params];

    NSMutableDictionary *formatTexts = [[NSMutableDictionary alloc] init];
    [formatTexts addEntriesFromDictionary: [NSDictionary dictionaryWithObjectsAndKeys:componentName,@"name", path,@"path", title,@"desc", key,@"key", nil]];
    [formatTexts setValue:componentTitle forKey:@"pageTitle"];
    if (subComponent != nil && subComponent.length > 0)
        [formatTexts setValue:subComponent forKey:@"subName"];
    NSNumber *nativeId = [SLConfig queryWithNSString:componentName withNSString:subComponent];
    if (nativeId) {
        [formatTexts setValue:[nativeId stringValue] forKey:@"nativeId"];
    }
    [[DisplayViewManager sharedInstance] setClickDesc:self texts:formatTexts];
}

- (UIViewController *)getViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            if ([next isKindOfClass:[UINavigationController class]]) {
                return ((UINavigationController *)next).topViewController;
            }
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);

    return nil;
}

- (NSString *)getViewControllerPath {
    UIViewController *viewController = [self getViewController];
    if (viewController != nil) {
        return [PathHelper getControllerPathFrom: viewController];
    }
    return nil;
}

- (UITableView *) myTableView {
    UIView * parent = self.superview;
    while (parent != nil) {
        if ([parent isKindOfClass: [UITableView class]])
            return (UITableView*) parent;
        parent = parent.superview;
    }
    return nil;
}

- (UICollectionView *) myCollectionView {
    UIView * parent = self.superview;
    while (parent != nil) {
        if ([parent isKindOfClass: [UICollectionView class]])
            return (UICollectionView*) parent;
        parent = parent.superview;
    }
    return nil;
}

- (NSString *)getViewPath {
    NSString * path = nil;
    UIResponder *next = self;
    UIViewController *viewController = [self getViewController];
    UIView * root = nil;
    if (viewController != nil)
        root = [viewController view];
    do {
        if ([next isKindOfClass: [UIWindow class]])
            break;
        NSString * index = @"";
        if ([next isKindOfClass: [UITableViewCell class]]) {
            UITableViewCell * cell = (UITableViewCell *) next;
            UITableView * table = cell.myTableView;
            if (table != nil) {
                NSIndexPath *indexPath = [table indexPathForCell: cell];
                index = [NSString stringWithFormat: @"[%ld,%ld]", indexPath.section, indexPath.row];
            }
        } else if ([next isKindOfClass: [UICollectionViewCell class]]) {
            UICollectionViewCell * cell = (UICollectionViewCell *) next;
            UICollectionView * table = cell.myCollectionView;
            if (table != nil) {
                NSIndexPath *indexPath = [table indexPathForCell: cell];
                index = [NSString stringWithFormat: @"[%ld,%ld]", indexPath.section, indexPath.row];
            }
        } else if ([next isKindOfClass: [UIView class]]) {
            UIView * view = (UIView *) next;
            UIView * parent = view.superview;
            if (parent != nil) {
                index = [NSString stringWithFormat: @"[%tu]", [parent.subviews indexOfObject: view]];
            }
        }
        if (path == nil)
            path = [NSString stringWithFormat: @"%@%@", [PathHelper getClassNameWithSender: next], index];
        else
            path = [NSString stringWithFormat: @"%@%@/%@", [PathHelper getClassNameWithSender: next], index, path];
        next = [next nextResponder];
    } while (next != root);
    return path;
}

- (NSTimeInterval)lastActionTime {
    return [objc_getAssociatedObject(self, &kLastActionTime) doubleValue];
}

- (void)setLastActionTime:(NSTimeInterval)lastActionTime {
    objc_setAssociatedObject(self, &kLastActionTime, @(lastActionTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
