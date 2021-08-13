//
//  JMMainViewController+Extension.swift
//  FormDemo
//
//  Created by 山神 on 2019/5/28.
//  Copyright © 2019 山神. All rights reserved.
//

import UIKit
import Eureka

// extension JMMainViewController {
    // MARK: - 简单
//    func formDemo()  {
//        
//        form
//            +++ Section("Section1")
//            <<< TextRow(){ row in
//                row.tag = "MyRowTag1"
//                row.title = "Text Row"
//                row.placeholder = "Enter text here"
//            }
//            <<< PhoneRow(){
//                $0.tag = "MyRowTag2"
//                $0.title = "Phone Row"
//                $0.placeholder = "And numbers here"
//            }
//            +++ Section("Section2")
//            <<< DateRow(){
//                $0.tag = "MyRowTag3"
//                $0.title = "Date Row"
//                $0.value = Date(timeIntervalSinceReferenceDate: 0)
//        }
//        // 开启导航辅助，并且遇到被禁用的行就隐藏导航
//        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
//        // 开启流畅地滚动到之前没有显示出来的行
//        animateScroll = true
//        // 设置键盘顶部和正在编辑行底部的间距为20
//        rowKeyboardSpacing = 20
//        
//        // 获取值
//        // 获取单个row的值
//        let row: DateRow? = form.rowBy(tag: "MyRowTag3")
//        let value = row?.value
//        print("------------1----------\(String(describing: value))")
//        // 获取表格中所有rows的值(必须给每个row的tag赋值)
//        // 字典中包含的键值对为：['rowTag': value]。
//        let valuesDictionary = form.values()
//        print("------------2----------\(valuesDictionary)")
//        
//        
//        form +++ Section("First Section") +++ Section("Another Section")
//        form +++ TextRow() +++ TextRow()
//        
//        form +++ SwitchRow("SwitchRow") { row in      // 初始化函数
//            row.title = "The title"
//            }.onChange { row in
//                row.title = (row.value ?? false) ? "The title expands when on" : "The title"
//                row.updateCell()
//            }.cellSetup { cell, row in
//                cell.backgroundColor = .lightGray
//            }.cellUpdate { cell, row in
//                cell.textLabel?.font = .italicSystemFont(ofSize: 18.0)
//            }
//            // MARK: - 自定义
//            +++  Section(){ section in
//                var header = HeaderFooterView<MyCustomUIView>(.class)
//                header.height = {100}
//                header.onSetupView = { view, _ in
//                    view.backgroundColor = .red
//                    view.name = "获取里面的view"
//                }
//                section.header = header
//            }
//            /// 自定义方式2
//            +++ Section(){ section in
//                section.header = {
//                    var header = HeaderFooterView<UIView>(.callback({
//                        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//                        view.backgroundColor = .green
//                        return view
//                    }))
//                    header.height = { 100 }
//                    return header
//                }()
//        }
//        // MARK: - 显示隐藏
//        form +++ Section("deleteTag")
//            <<< SwitchRow("switchRowTag"){
//                $0.title = "Show message"
//            }
//            <<< LabelRow(){
//                $0.hidden = Condition.function(["switchRowTag"], { form in
//                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
//                })
//                $0.title = "Switch is on!"
//        }
//        // 自定义section 并且标记section  删除section
//        let section = Section{ section in
//            section.tag = "action"
//        }
//        form  +++ section
//        section <<< TextRow("测试", { (row) in
//            row.title = "最后的测试"
//        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let sectionTag: Section?  = self.form.sectionBy(tag: "action")
//            sectionTag?.remove(at: 0)
//            let row = LabelRow(){ row in
//                row.title = "通过append的方式添加"
//            }
//            sectionTag?.append(row)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            let sectionTag: Section?  = self.form.sectionBy(tag: "action")
//            sectionTag?.hidden = true
//        }
//        
//        // 选中
//        form +++ SelectableSection<ListCheckRow<String>>("Where do you live", selectionType: .singleSelection(enableDeselection: true))
//        let continents = ["Africa", "Antarctica", "Asia", "Australia", "Europe", "North America", "South America"]
//        for option in continents {
//            form.last! <<< ListCheckRow<String>(option){ listRow in
//                listRow.title = option
//                listRow.selectableValue = option
//                if listRow.title == "Africa" {
//                    listRow.value =  "Africa"
//                }
//            }
//        }
//        
//        // MARK: - 多值的section
//          let multiSetction =  MultivaluedSection(multivaluedOptions: [.Reorder, .Insert],
//                               header: "Multivalued TextField",
//                               footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") {
//                                $0.addButtonProvider = { section in
//                                    return ButtonRow(){row in
//                                        row.title = "Add New Tag"
//                                    }
//                                }
//                                $0.multivaluedRowToInsertAt = { index in
//                                    return NameRow() {
//                                        $0.placeholder = "Tag Name \(index)"
//                                    }
//                                }
//                                $0 <<< NameRow() {
//                                    $0.placeholder = "Tag Name"
//                                }
//        }
//         form +++ multiSetction
//        print("------\(multiSetction.allRows)")
//        
//    
//        // MARK: - 验证规则
//        form
//            +++ Section(header: "Required Rule", footer: "Options: Validates on change")
//            
//            <<< TextRow() {
//                $0.title = "Required Rule"
//                $0.add(rule: RuleRequired())
//                
//                // 这也可以通过一个闭包来实现：如果验证通过，返回nil，否则返回一个ValidationError。
//                /*
//                 let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
//                 return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Field required!") : nil
//                 }
//                 $0.add(rule: ruleRequiredViaClosure)
//                 */
//                
//                $0.validationOptions = .validatesOnChange
//                }
//                .cellUpdate { cell, row in
//                    if !row.isValid {
//                        cell.titleLabel?.textColor = .red
//                    }
//            }
//            
//            +++ Section(header: "Email Rule, Required Rule", footer: "Options: Validates on change after blurred")
//            
//            <<< TextRow() {
//                $0.title = "Email Rule"
//                $0.add(rule: RuleRequired())
//                $0.add(rule: RuleEmail())
//                $0.validationOptions = .validatesOnChangeAfterBlurred
//                }
//                .cellUpdate { cell, row in
//                    if !row.isValid {
//                        cell.titleLabel?.textColor = .red
//                    }
//        }
//        
//        // MARK: - 自定义row实现
//            <<< CustomRow("自定义", { (row) in
//                
//            })
//        
//            <<< SegmentedRow<String>(){
////                $0.title = "SegmentedRow"
//                $0.options = ["One", "Two"]
//                $0.baseCell.backgroundColor = UIColor.red
//                $0.cell.segmentedControl.backgroundColor = UIColor.yellow
//                }.cellSetup { cell, row in
//                    cell.imageView?.image = UIImage(named: "plus_image")
//        }
//        
//            <<< AlertRow<String>() {
//                $0.title = "AlertRow"
//                $0.cancelTitle = "Dismiss"
//                $0.selectorTitle = "Who is there?"
//                $0.options = ["cd","cwdc","cwevvg "]
//                $0.value = "cecev"
//                }.onChange { row in
//                    print(row.value ?? "No Value")
//                }
//                .onPresent{ _, to in
//                    to.view.tintColor = .purple
//        }
//        
//        self.form.allRows.first { (row) -> Bool in
//            return true
//        }
//        
//        
//    }
//
// }

// 自定义value类型是Bool的Cell
// Cell是使用 .xib 定义的，所以我们可以直接设置outlets
// public class CustomCell: Cell<Bool>, CellType {
//    
//    private var switchControl = UISwitch(frame: CGRect(x: 200, y: 10, width: 50, height: 44))
//    private var label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 44))
//    
//    public override func setup() {
//        super.setup()
//        addSubview(switchControl)
//        addSubview(label)
//        label.text = "Cell是使用 .xib 定义的，所以我们可以直接设置outlets"
//        switchControl.addTarget(self, action: #selector(CustomCell.switchValueChanged), for: .valueChanged)
//    }
//    
//    @objc func switchValueChanged(){
//        row.value = switchControl.isOn
//        row.updateCell() // Re-draws the cell which calls 'update' bellow
//    }
//    
//    public override func update() {
//        super.update()
//        backgroundColor = (row.value ?? false) ? .white : .green
//    }
// }
//
//// 自定义的Row，拥有CustomCell和对应的value
// public final class CustomRow: Row<CustomCell>, RowType {
//    required public init(tag: String?) {
//        super.init(tag: tag)
//        // 我们把对应CustomCell的 .xib 加载到cellProvidor
//        cellProvider = CellProvider<CustomCell>()
//    }
// }
//
//
//
//
// class MyCustomUIView: UIView {
//    var name:String = "金山" {
//        didSet{
//            label.text = name
//        }
//    }
//    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        label.text = "测试"
//        addSubview(label)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
// }
