//
//  HookNameMapper.swift
//  blackboard
//
//  Created by 郭春茂 on 2021/1/4.
//  Copyright © 2021 xkb. All rights reserved.
//

import Foundation
import LogicBehind

class HookNameMapper: NSObject {

    @objc static let instance = HookNameMapper()

    public var autoUpload = false

    private var stopAction: Bool = false

    private var nameMapping: [String: [String: String?]] = [:]

    @objc func shouldStopAction() -> Bool {
        return stopAction
    }

    func setStopAction(_ b: Bool) {
        stopAction = b
    }

    func submitMapping(_ view: UIView?, _ texts: [String: String], _ auto: Bool) -> SLObservable {
        guard let view = view else { return SLObservable_empty() }
        guard let name = texts["name"] else { return SLObservable_empty() }
        var m = name
        if let sub = texts["subName"], !sub.isEmpty {
            m.append("#\(sub)")
        }
        let p = texts["path"] ?? ""
        let d = texts["desc"]
        if let map = nameMapping[m] {
            if auto && map.keys.contains(p) {
                print("HookNameMapper skip \(m) \(p)")
                return SLObservable_empty()
            }
            var map2 = map
            map2[p] = texts["desc"]
            nameMapping[m] = map2
        } else {
            nameMapping[m] = [p: d]
        }
        print("HookNameMapper submit \(m) \(p)")
        let request = SLAddElementRequest()
        request.setPlatformWith("iOS")
        request.setOverrideWithBoolean(!auto)
        request.setPageWithBoolean(texts["path"] == nil)
        request.setComponentNameWith(m)
        request.setPathWith(texts["path"])
        request.setNameWith(texts["desc"] ?? "")
        request.setPageTitleWith(texts["pageTitle"] ?? "")
        let picture: UIImage?
        let pageView = PathHelper.takeScreenshotWithoutHookView()
        if texts["path"] != nil {
            let imageData = pageView?.jpegData(compressionQuality: 0.6)
            let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
            print("HookNameMapper full picture \(strBase64?.utf8.count ?? 0)")
            request.setFullPictureWith(strBase64 ?? "")
            request.setPositionWith(getViewPostion(view))
            picture = view.viewSnapshot()
        } else {
            picture = pageView
        }
        print("HookNameMapper picture \(String(describing: picture?.size))")
        let imageData = picture?.jpegData(compressionQuality: 0.6)
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        print("HookNameMapper picture \(strBase64?.utf8.count ?? 0)")
        request.setPictureWith(strBase64 ?? "")
        return SLAddElementPacket(slAddElementRequest: request).send()
    }

    func loadSavedData() -> SLObservable {
        let request = SLAppQueryListRequest()
        request.setPlatformWith("iOS")
        return SLAppQueryElementPacket(slAppQueryListRequest: request).send().map(with: ValueMapper<SLAppQueryListResponse, SLEmptyResponse>({[self] (data) in
            self.loadData(data.getItems())
            return SLEmptyResponse()
        }))
    }

    func loadData(_ items: JavaUtilArrayList) {
        for v: SLAppQueryResponseItem in items.asArray() {
            let m = v.getComponentName()
            var map = nameMapping[m]
            if map == nil {
                map = [:]
            }
            let p = v.isPage() ? "" : v.getPath() ?? ""
            map?[p] = v.getName()
            nameMapping[m] = map
        }
    }

    func getViewPostion(_ view: UIView) -> SLPosition {
        let frame = view.convert(view.bounds, to: PathHelper.getTopWindowRootView())
        guard let winFrame = PathHelper.getTopWindowRootView()?.bounds else {
            return SLPosition()
        }
        let p = SLPosition()
        p.setXStartWith((Int32)(frame.minX * 10000 / winFrame.width))
        p.setYStartWith((Int32)(frame.minY * 10000 / winFrame.height))
        p.setXEndWith((Int32)(frame.maxX * 10000 / winFrame.width))
        p.setYEndWith((Int32)(frame.maxY * 10000 / winFrame.height))
        return p
    }

    func fillName(_ texts: inout [String: String]) {
        guard let name = texts["name"] else { return }
        var m = name
        if let sub = texts["subName"] {
            m.append("#\(sub)")
        }
        let p = texts["path"] ?? ""
        if let map = nameMapping[m], let d = map[p] {
            texts["desc"] = d
        }
    }

}
