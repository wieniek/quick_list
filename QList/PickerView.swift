//
//  PickerView.swift
//  QList
//
//  Created by Home on 3/19/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

@IBDesignable
class PickerView: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    
    var dataProvider: DataProvider?
    var selectedItemName: String?
    
    private lazy var pickerTable: UITableView = {
        [unowned self] in
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 40
        $0.separatorColor = UIColor.black //.lightGray.withAlphaComponent(0.4)
        $0.bounces = false
        $0.backgroundColor = nil
        $0.tableFooterView = UIView()
        $0.sectionIndexBackgroundColor = .clear
        $0.sectionIndexTrackingBackgroundColor = .clear
        $0.layer.cornerRadius = 20
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewElements()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewElements()
    }
    
    // MARK: UI Methods
    private func setupViewElements() {
        layer.cornerRadius = CGFloat(20)
        backgroundColor = colorPastel4?.darken(byPercentage: 0.1)
        addSubview(pickerTable)
        pickerTable.register(PickerCell.self, forCellReuseIdentifier: "pickerCell")
        pickerTable.frame = self.bounds
    }
    
    func refresh() {
        pickerTable.reloadData()
    }
    
    // MARK: Protocol methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as! PickerCell
        let category = dataProvider!.categories[indexPath.row]
        cell.textLabel?.text = category.icon + " - " + category.name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataProvider = dataProvider {
            return dataProvider.categories.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        if let newCategory = dataProvider?.categories[indexPath.row], let selectedItemName = selectedItemName {
            dataProvider?.updateItem(named: selectedItemName, withCategory: newCategory)
        }
        isHidden = true
    }
}
