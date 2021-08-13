//
//  HookDisplayView.swift
//  blackboard
//
//  Created by roni on 2019/4/28.
//  Copyright © 2019 xkb. All rights reserved.
//

import UIKit
import SnapKit
import Core
import Skin
import LogicBehind
import HUD

enum DraggingType {
    case disabled // 不能拖动
    case normal // 正常拖拽
    case revert // 释放后还原
    case pullOver // 自动靠边
    case adsorb // 靠边时自动吸附边缘,可吸附四周
}

protocol DraggingProtocol: AnyObject {
    func draggingDidBegan(view: UIView)
    func draggingDidChanged(view: UIView)
    func draggingDidEnded(view: UIView)
}

struct DraggingStyle: Equatable {
    var draggingType: DraggingType = .normal
    /*: 是否只能在 subView 的范围内,默认 true
     *Tips: 如果 false, 超出 subView 范围的部分无法响应拖拽. 剪裁超出部分可以直接使用 superView.clipsToBounds = true
     */
    var draggingInBounds: Bool = true

    init(draggingType: DraggingType, draggingInBounds: Bool) {
        self.draggingType = draggingType
        self.draggingInBounds = draggingInBounds
    }

    init() {}

    static func == (lhs: DraggingStyle, rhs: DraggingStyle) -> Bool {
        if lhs.draggingType == rhs.draggingType && lhs.draggingInBounds == rhs.draggingInBounds {
            return true
        }
        return false
    }
}

class HookDisplayView: UIView {

    private var style: DraggingStyle {
        didSet {
            setPanGesture()
        }
    }

    private var canEdit = false
    private var canEditChanged = true

    init(frame: CGRect, style: DraggingStyle) {
        self.style = style
        super.init(frame: frame)

        backgroundColor = ThemeColor.shared.bluegrey_50
        setPanGesture()
        configUI()
        self.updateTexts()
        HookNameMapper.instance.loadSavedData().subscribe(with: ValueObserver<Any>.observe(value: { [self] _ in
            self.canEdit = true
            self.canEditChanged = true
            self.updateTexts()
        }, error: { [self] _ in
            self.canEdit = false
            self.canEditChanged = true
            self.updateTexts()
        }))
    }

    convenience override init(frame: CGRect) {
        self.init(frame: frame, style: DraggingStyle())
    }

    private var panGesture: UIPanGestureRecognizer?
    private var revertCenter: CGPoint?

    private func draggable() -> Bool {
        if style.draggingType == .disabled {
            return false
        }

        return true
    }

    private func setPanGesture() {
        if !draggable() {
            removePanGesture()
            return
        }
        addPanGesture()
    }

    private func addPanGesture() {
        if panGesture == nil {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragAction(panGestureRecognizer:)))
            self.addGestureRecognizer(panGesture!)
        }
    }

    private func removePanGesture() {
        if let pan = panGesture {
            self.removeGestureRecognizer(pan)
            panGesture = nil
        }
    }

    // you can conform to this protocol so that you can do sth in your page
    public weak var delegate: DraggingProtocol?

    private weak var pageView: UIView?
    private weak var itemView: UIView?
    private var pageTexts: [String: String] = [:]
    private var itemTexts: [String: String] = [:]
    public var dragCenter = CGPoint(x: 250, y: 300)

    public func resetStyle(style: DraggingStyle) {
        if self.style != style {
            self.style = style
        }
    }

    public func setViewDidLoadDesc(texts: [String: String]) {
        if texts["name"] != self.pageTexts["name"] {
            self.itemTexts = [:]
        }
        self.pageView = PathHelper.getTopWindowRootView()
        self.pageTexts = texts
        HookNameMapper.instance.fillName(&self.pageTexts)
        self.itemView = nil
        DispatchQueue.main.async {
            self.updateTexts()
        }
        if canEdit {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                if view == self.pageView {
//                    let root = PathHelper.getTopWindow().rootViewController
                    self.submit(PathHelper.getTopWindowRootView(), texts, true, isPage: true)
//                }
            }
        }
    }

    public func setItemDesc(_ view: UIView, texts: [String: String]) {
        self.itemView = view
        self.itemTexts = texts
        if texts["name"] == self.pageTexts["name"] {
            self.pageTexts["subName"] = texts["subName"]
        }
        HookNameMapper.instance.fillName(&self.itemTexts)
        DispatchQueue.main.async {
            self.updateTexts()
        }
        if canEdit {
            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if view == self.itemView {
                    self.submit(view, texts, true, isPage: false)
                }
            // }
        }
    }

    private func updateTexts() {
        if canEditChanged {
            canEditChanged = false
            pageTitleView.isEditable = canEdit && false
            pageSubmitButton.isHidden = !canEdit
            itemTitleView.isEditable = canEdit
            itemSubmitButton.isHidden = !canEdit
            stopActionButton.isHidden = !canEdit
        }
        setDescTexts(isResult: false, isPage: false, result: "")
        self.center = dragCenter
    }

    private func setDescTexts(isResult: Bool, isPage: Bool, result: String) {
        let sub = pageTexts["subName"] != nil ? "#\(pageTexts["subName"]!)" : ""
        self.pageTitleView.text = pageTexts["desc"]

        var pageText = """
name: \(pageTexts["name"] ?? "")\(sub)
nativeId: \(pageTexts["nativeId"] ?? "")
"""
        if isResult && isPage {
            pageText += "\n" + result
        }
        self.pageTextView.text = pageText

        self.itemTitleView.text = itemTexts["desc"]
        var itemText = """
path: \(itemTexts["path"] ?? "")
nativeId: \(itemTexts["nativeId"] ?? "")
key: \(itemTexts["key"] ?? "")
"""
        if isResult && !isPage {
            itemText += "\n" + result
        }
        self.itemTextView.text = itemText
    }

    private func submit(_ view: UIView?, _ texts: [String: String], _ auto: Bool, isPage: Bool) {
        if !HookNameMapper.instance.autoUpload && auto {
            return
        }
        let observable = HookNameMapper.instance.submitMapping(view, texts, auto)
        if !auto {
            observable.onInterest(with: HttpLoadingInterest())
        }
        observable.subscribe(with: ValueObserver<Any>.observe(value: { _ in
                if isPage {
                    self.setDescTexts(isResult: true, isPage: isPage, result: "result: \(self.pageTexts["name"] ?? "") 上传成功")
                } else {
                    self.setDescTexts(isResult: true, isPage: isPage, result: "result: \(self.itemTexts["desc"] ?? "") 上传成功")
                }
            }, error: { (e) in
                self.setDescTexts(isResult: true, isPage: isPage, result: "result:\(e.localizedDescription)")
            }, completion: {}))
    }

    private func configUI() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        containerView.addSubview(dragButton)
        dragButton.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.height.equalTo(30)
        }

        containerView.addSubview(maxButton)
        maxButton.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.leading.equalTo(dragButton.snp.trailing)
            make.height.equalTo(30)
            make.width.equalTo(dragButton.snp.width)
        }

        containerView.addSubview(pageButton)
        pageButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(maxButton.snp.bottom).offset(10)
            make.width.equalTo(90)
            make.height.equalTo(20)
        }

        containerView.addSubview(pageTitleView)
        pageTitleView.snp.makeConstraints { (make) in
            make.leading.equalTo(pageButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(pageButton.snp.top)
            make.height.equalTo(30)
        }

        containerView.addSubview(pageTextView)
        pageTextView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(pageTitleView.snp.bottom).offset(10)
            make.height.equalTo(60)
        }

        containerView.addSubview(pageSubmitButton)
        pageSubmitButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(pageTextView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }

        containerView.addSubview(itemButton)
        itemButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(pageSubmitButton.snp.bottom).offset(10)
            make.width.equalTo(90)
            make.height.equalTo(20)
        }

        containerView.addSubview(itemTitleView)
        itemTitleView.snp.makeConstraints { (make) in
            make.leading.equalTo(itemButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(itemButton.snp.top)
            make.height.equalTo(30)
        }

        containerView.addSubview(itemTextView)
        itemTextView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(itemTitleView.snp.bottom).offset(10)
            make.height.equalTo(90)
        }

        containerView.addSubview(stopActionButton)
        stopActionButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(itemTextView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }

        containerView.addSubview(itemSubmitButton)
        itemSubmitButton.snp.makeConstraints { (make) in
            make.leading.equalTo(stopActionButton.snp.trailing).offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(stopActionButton.snp.top)
            make.height.equalTo(stopActionButton.snp.height)
            make.width.equalTo(stopActionButton.snp.width)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.addSubview(switchLabel)
        switchLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-6)
        }

        self.addSubview(uploadSwitch)
        uploadSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(switchLabel.snp.right).offset(8)
            make.centerY.equalTo(switchLabel)
        }

        dragButton.addTarget(self, action: #selector(dragAction(sender:)), for: .touchUpInside)
        maxButton.addTarget(self, action: #selector(changeFrameAction(sender:)), for: .touchUpInside)
        stopActionButton.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        itemSubmitButton.addTarget(self, action: #selector(itemSubmitAction), for: .touchUpInside)
        pageSubmitButton.addTarget(self, action: #selector(pageSubmitAction), for: .touchUpInside)
        uploadSwitch.addTarget(self, action: #selector(setAutoUpload), for: .valueChanged)
        pageButton.addTarget(self, action: #selector(onCopy(button:)), for: .touchUpInside)
        itemButton.addTarget(self, action: #selector(onCopy(button:)), for: .touchUpInside)
    }

    @objc func setAutoUpload() {
        HookNameMapper.instance.autoUpload = uploadSwitch.isOn
    }

    @objc func onCopy(button: UIButton) {
        if button == pageButton {
            UIPasteboard.general.string = pageTextView.text
            HUD.tip(text: "页面信息已复制")
        } else {
            UIPasteboard.general.string = itemTextView.text
            HUD.tip(text: "元素信息已复制")
        }
    }

    @objc func stopAction() {
        let b = !stopActionButton.isSelected
        stopActionButton.isSelected = b
        HookNameMapper.instance.setStopAction(b)
        stopActionButton.backgroundColor = b ? UIColor.blue : ThemeColor.shared.bluegrey_50
    }

    @objc func dragAction(sender: UIButton) {
        if style.draggingType == .disabled {
            style.draggingType = .normal
            sender.setTitle("关闭拖拽", for: .normal)
        } else {
            style.draggingType = .disabled
            sender.setTitle("打开拖拽", for: .normal)
        }
    }

    @objc func changeFrameAction(sender: UIButton) {
        if sender.tag == 1 {
            sender.setTitle("缩小", for: .normal)
            self.snp.updateConstraints { (make) in
                make.leading.equalToSuperview().offset(self.hw_left)
                make.top.equalToSuperview().offset(self.hw_top)
                make.size.equalTo(CGSize(width: ScreenWidth * 0.75, height: 400))
            }
            sender.tag = 2
        } else {
            sender.setTitle("放大", for: .normal)
            self.snp.updateConstraints { (make) in
                make.leading.equalToSuperview()
                make.top.equalToSuperview().offset(200)
                make.size.equalTo(CGSize(width: 150, height: 100))
            }
            sender.tag = 1
        }
        containerView.superview?.layoutIfNeeded()
    }

    @objc func pageSubmitAction(sender: UIButton) {
        pageTexts["desc"] = self.pageTitleView.text
        submit(pageView, pageTexts, false, isPage: true)
    }

    @objc func itemSubmitAction(sender: UIButton) {
        itemTexts["desc"] = self.itemTitleView.text
        if itemView?.superview == nil {
            HUD.tip(text: "该元素页面已销毁,如需上传请先拦截操作")
            return
        }
        submit(itemView, itemTexts, false, isPage: false)
    }

    private let pageButton: UIButton = {
        let button = UIButton()
        button.setTitle("页面信息: ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(ThemeColor.shared.red_600, for: .normal)
        return button
    }()

    private let pageTitleView: UITextView = UITextView()

    private let pageTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()

    private let itemButton: UIButton = {
        let button = UIButton()
        button.setTitle("元素信息: ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(ThemeColor.shared.red_600, for: .normal)
        return button
    }()

    private let itemTitleView: UITextView = UITextView()

    private let itemTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()

    private let pageSubmitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("上传映射", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = ThemeColor.shared.bluegrey_50
        button.setTitleColor(ThemeColor.shared.bluegrey_900, for: .normal)
        return button
    }()

    private let dragButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("关闭拖拽", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    private let maxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("缩小", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .black
        button.setTitleColor(.red, for: .normal)
        button.tag = 2
        return button
    }()

    private let stopActionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("拦截操作", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = ThemeColor.shared.bluegrey_50
        button.setTitleColor(ThemeColor.shared.bluegrey_900, for: .normal)
        return button
    }()

    private let itemSubmitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("上传映射", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = ThemeColor.shared.bluegrey_50
        button.setTitleColor(ThemeColor.shared.bluegrey_900, for: .normal)
        return button
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return view
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0xC0)
        return scrollView
    }()

    private let uploadSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = ThemeColor.shared.brand_500
        return switchButton
    }()

    private let switchLabel: UILabel = {
        let label = UILabel()
        label.text = "自动上传"
        label.font = systemFontSize(fontSize: 14)
        label.textColor = .white
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HookDisplayView {

    @objc private func dragAction(panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .began:
            // bringViewBack()
            revertCenter = center
            dragging(panGestureRecognizer: panGestureRecognizer)
            delegate?.draggingDidBegan(view: self)
        case .changed:
            dragging(panGestureRecognizer: panGestureRecognizer)
            delegate?.draggingDidChanged(view: self)
        case .ended:
            switch style.draggingType {
            case .revert:
                revert(animated: true)
            case .pullOver:
                pullOver(animated: true)
            case .adsorb:
                adsorbing(animated: true)
            default:
                dragEnd()
            }
            delegate?.draggingDidEnded(view: self)
        default:
            break
        }
    }

    private func dragging(panGestureRecognizer: UIPanGestureRecognizer) {
        guard let view = panGestureRecognizer.view else { return }
        let translation = panGestureRecognizer.translation(in: view.superview)
        var aCenter = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        if style.draggingInBounds {
            guard let superView = view.superview else { return }
            let size = view.frame.size
            let superSize = superView.frame.size
            let width = size.width
            let height = size.height
            let superWidth = superSize.width
            let superHeight = superSize.height

            aCenter.x = (aCenter.x < width / 2) ? width / 2 : aCenter.x
            aCenter.x = (aCenter.x + width / 2 > superWidth) ? superWidth - width / 2 : aCenter.x

            aCenter.y = (aCenter.y < height / 2) ? height / 2 : aCenter.y
            aCenter.y = (aCenter.y + height / 2 > superHeight) ? superHeight - height / 2 : aCenter.y
        }

        dragCenter = aCenter
        view.center = aCenter
        panGestureRecognizer.setTranslation(.zero, in: view.superview)
    }

    private func dragEnd() {
        self.snp.updateConstraints { (make) in
            make.leading.equalToSuperview().offset(self.hw_left)
            make.top.equalToSuperview().offset(self.hw_top)
            make.size.equalTo(CGSize(width: self.hw_width, height: self.hw_height))
        }
    }

    func sendToView(view: UIView?) {
        let convertRect = superview?.convert(frame, to: view)
        view?.addSubview(self)
        if let rect = convertRect {
            self.frame = rect
        }
    }

    func bringViewBack() {
        guard let adsorbingView = superview else { return }
        sendToView(view: adsorbingView.superview)
        adsorbingView.removeFromSuperview()
    }

    // 主动靠边并吸附
    public func adsorbing(animated: Bool) {
        let aCenter = centerByPullOver()
        UIView.animate(withDuration: animated ? 0.5 : 0, animations: {
            self.center = aCenter
        }) { (isFinished) in
            if isFinished {
                self.adsorbing(animated: animated)
            }
        }
    }

    // 主动靠边
    public func pullOver(animated: Bool) {
        bringViewBack()
        let aCenter = centerByPullOver()
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.center = aCenter
        }
    }

    private func centerByPullOver() -> CGPoint {
        var currentCenter = center
        let size = frame.size
        guard let superSize = superview?.frame.size else {
            return currentCenter
        }
        if currentCenter.x < superSize.width / 2 {
            currentCenter.x = size.width / 2
        } else {
            currentCenter.x = superSize.width - size.width / 2
        }
        if currentCenter.y < size.height / 2 {
            currentCenter.y = size.height / 2
        } else if currentCenter.y > superSize.height - size.height / 2 {
            currentCenter.y = superSize.height - size.height / 2
        }

        return currentCenter
    }

    // 主动还原位置
    public func revert(animated: Bool) {
        bringViewBack()
        if let aCenter = revertCenter {
            UIView.animate(withDuration: animated ? 0.5 : 0) {
                self.center = aCenter
            }
        }
    }
}
