//
//  OSSNetworking+Hook.m
//  blackboard
//
//  Created by 李俊毅 on 2020/4/22.
//  Copyright © 2020 xkb. All rights reserved.
//

#import "OSSNetworking+Hook.h"
#import <XHBMars/Mars.h>

@implementation OSSNetworking (Hook)


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
//    SLHttpRequest *request = [SLHttpRequest createWithNSString:task.currentRequest.URL.absoluteString withNSString:task.currentRequest.HTTPMethod];
//
//    SLHttpEventListener *listener = [[[SLDeviceDependence current] getHttpEventFactory] create];
//
    NSURLSessionTaskTransactionMetrics *m = metrics.transactionMetrics.lastObject;
//    [listener onCallStartWithSLHttpRequest:request withLong:m.fetchStartDate == nil ? 0 : m.fetchStartDate.timeIntervalSince1970 * 1000];
//    [listener onDnsStartWithLong:m.domainLookupStartDate == nil ? 0: m.domainLookupStartDate.timeIntervalSince1970 * 1000];
//    [listener onDnsEndWithLong:m.domainLookupEndDate == nil ? 0 : m.domainLookupEndDate.timeIntervalSince1970 * 1000];
//    [listener onConnectStartWithLong:m.connectStartDate == nil ? 0 : m.connectStartDate.timeIntervalSince1970 * 1000];
//    [listener onSecureConnectStartWithLong:m.secureConnectionStartDate == nil ? 0 : m.secureConnectionStartDate.timeIntervalSince1970 * 1000];
//    [listener onSecureConnectEndWithLong:m.secureConnectionEndDate == nil ? 0 : m.secureConnectionEndDate.timeIntervalSince1970 * 1000];
//    [listener onConnectEndWithLong:m.connectEndDate == nil ? 0 : m.connectEndDate.timeIntervalSince1970 * 1000];
//    [listener onRequestHeadersStartWithLong:m.requestStartDate == nil ? 0 : m.requestStartDate.timeIntervalSince1970 * 1000];
//    [listener onRequestHeadersEndWithLong:m.requestEndDate == nil ? 0 : m.requestEndDate.timeIntervalSince1970 * 1000];
//    [listener onResponseBodyStartWithLong:m.responseStartDate == nil ? 0 : m.responseStartDate.timeIntervalSince1970 * 1000];
//    [listener onResponseBodyEndWithLong:m.responseEndDate == nil ? 0 : m.responseEndDate.timeIntervalSince1970 * 1000];
//    [listener onCallEndWithLong:m.responseEndDate == nil ? 0 : m.responseEndDate.timeIntervalSince1970 * 1000];
    
    OSSLogDebug(@"[OSSNetWorkMetrics]: url %@", task.currentRequest.URL.absoluteString);
    OSSLogDebug(@"[OSSNetWorkMetrics]: fetchStartDate %.2f", m.fetchStartDate == nil ? 0 : m.fetchStartDate.timeIntervalSince1970 * 1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: dnsStart %.2f", m.domainLookupStartDate == nil ? 0: m.domainLookupStartDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: dnsEnd %.2f", m.domainLookupEndDate == nil ? 0 : m.domainLookupEndDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: connectStart %.2f", m.connectStartDate == nil ? 0 : m.connectStartDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: secureStart %.2f", m.secureConnectionStartDate == nil ? 0 : m.secureConnectionStartDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: secureEnd %.2f", m.secureConnectionEndDate == nil ? 0 : m.secureConnectionEndDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: connectEnd %.2f", m.connectEndDate == nil ? 0 : m.connectEndDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: requestStart %.2f", m.requestStartDate == nil ? 0 : m.requestStartDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: requestEnd %.2f", m.requestEndDate == nil ? 0 : m.requestEndDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: responseStart %.2f", m.responseStartDate == nil ? 0 : m.responseStartDate.timeIntervalSince1970*1000);
    OSSLogDebug(@"[OSSNetWorkMetrics]: responseEnd %.2f", m.responseEndDate == nil ? 0 : m.responseEndDate.timeIntervalSince1970*1000);
}

@end
