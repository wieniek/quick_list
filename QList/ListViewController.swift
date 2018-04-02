//
//  ListViewController.swift
//  QList
//
//  Created by Home on 1/21/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import BEMCheckBox
import ChameleonFramework

let colorPastel1 = HexColor("B8DBD3")
let colorPastel2 = HexColor("F7E7B4")
let colorPastel3 = HexColor("68C4AF")
let colorPastel4 = HexColor("96EAD7")
let colorPastel5 = HexColor("F2F6C3")

enum TableViewMode {
    case displaySelectedItems([Item])
    case displayAvailableChoices([Item])
    case displaySearchResults([Item])
}

class ListViewController: UIViewController, UISearchBarDelegate, DataProviderDelegate {
    // DataProviderDelegate protocol required method
    func dataProviderDidUpdate() {
        reloadData()
    }
    
    var dataProvider: DataProvider!
    var foundItems = [Item]()
    var searchBarIsInFocus = false
    var tableViewMode: TableViewMode {
            // when searchbar selected and no search text
            if searchBarIsEmpty && searchBarIsInFocus {
                return .displayAvailableChoices(notSelectedItems)
            }
            // when searchbar selected and there is search text then show search results
            if searchBarIsInFocus {
                return .displaySearchResults(foundItems)
            }
            // when searchbar not selected and no search text then show selected items only
            return .displaySelectedItems(selectedItems)
    }
    
    var selectedItems: [Item] {
        return dataProvider.items.filter({ (item: Item) -> Bool in
            return item.isSelected
        }).sorted(by: { (item1, item2) -> Bool in
            if item2.isCompleted {
                return true
            } else if item1.isCompleted {
                return false
            }
            return item1.category.order < item2.category.order
        })
    }
    var notSelectedItems: [Item] {
        return dataProvider.items.filter({ (item: Item) -> Bool in
            return !item.isSelected
        })
    }
    var completedItems: [Item] {
        return dataProvider.items.filter({ (item: Item) -> Bool in
            return item.isCompleted
        })
    }
    
    let searchBar = UISearchBar()
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    @IBAction func barButtonTap(_ sender: UIBarButtonItem) {
        
        
        if completedItems.count > 0 {
            dataProvider.deselectAllCompletedItems()
        } else if selectedItems.count > 0 {
            dataProvider.deselectAllSelectedItems()
        }
    }
    
    
    
    // given item name returns its index in the items array
    func indexOfItem(withName name:String) -> Int? {
        let index = dataProvider.items.index { (item: Item) -> Bool in
            return item.name.lowercased() == name.lowercased()
        }
        return index
    }

    func reloadData() {
        switch tableViewMode {
        case .displayAvailableChoices :
            searchBar.placeholder = "Type Item Name"
            searchBar.showsCancelButton = true
            toolBar.isHidden = false
            barButton.title = ""
            barButton.isEnabled = true
        case .displaySearchResults :
            searchBar.placeholder = ""
            toolBar.isHidden = true
            barButton.title = ""
            barButton.isEnabled = false
        case .displaySelectedItems :
            searchBar.placeholder = "Tap to Add Item"
            toolBar.isHidden = false
            if completedItems.count > 0 {
                barButton.isEnabled = true
                barButton.title = "Remove Completed"
            } else if selectedItems.count > 0 {
                barButton.isEnabled = true
                barButton.title = "Remove All Items"
            } else {
                barButton.isEnabled = false
                barButton.title = ""
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarSetup()
        
        dataProvider.delegate = self
        
        let nib = UINib(nibName: "DescriptionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DescriptionCell")
        
        tableView.separatorStyle = .none

        navigationController?.navigationBar.barTintColor = colorPastel3?.darken(byPercentage: 0.1)
        toolBar.barTintColor = colorPastel3?.darken(byPercentage: 0.1)
        let colors = [colorPastel1!, colorPastel5!]
        tableView.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: TableView Delegates

extension ListViewController: UITableViewDelegate, UITableViewDataSource, ItemCellDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch tableViewMode {
        case .displaySelectedItems(let displayedItems) :
            // remove from selected items
            let removeAction = UIContextualAction(style: .normal, title: "Remove") { (action: UIContextualAction, sourceView: UIView, actionPerformed:(Bool)-> ()) in
                self.dataProvider.deselectItem(withName: displayedItems[indexPath.row].name)
                actionPerformed(true)
            }
            //return defined remove swipe action
            return UISwipeActionsConfiguration(actions: [removeAction])
        case .displaySearchResults(let displayedItems), .displayAvailableChoices(let displayedItems) :
            // permanently delete from the items list
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action: UIContextualAction, sourceView: UIView, actionPerformed:(Bool)-> ()) in
                self.dataProvider.removeItem(withName: displayedItems[indexPath.row].name)
                self.searchBar.text = nil
                actionPerformed(true)
            }
            //return defined delete swipe action
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
    
    // ItemCellDelegate protocol implementation
    func didUpdateCell(withLabel label: UILabel, andCheckmark checkmark: BEMCheckBox) {
        // update item completed state
        dataProvider.updateItem(named: label.text!, completedState: checkmark.on)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsEmpty {
            
            if searchBarIsInFocus {
                print("Edit begin.....")
                return notSelectedItems.count
            } else {
                return selectedItems.count
            }
        } else {
            return foundItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set different colors for alternate rows
        var cellBackgroundColor: UIColor!
        if indexPath.row % 2 == 0 {
            cellBackgroundColor = colorPastel5?.lighten(byPercentage: 0.8)
        } else {
            cellBackgroundColor = colorPastel5?.darken(byPercentage: 0.1)
        }
        
        switch tableViewMode {
        case .displaySelectedItems(let itemsToDisplay) :
            searchBar.showsCancelButton = false
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            itemCell.delegate = self
            itemCell.itemLabel.text = itemsToDisplay[indexPath.row].name
            itemCell.itemCheckmark.setOn(itemsToDisplay[indexPath.row].isCompleted, animated: true)
                        
            itemCell.backgroundColor = cellBackgroundColor
            // customize cell accessory view with a button
            if let icon = itemsToDisplay[indexPath.row].category.icon.image() {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: icon.size.width, height: icon.size.height)
                button.setBackgroundImage(icon, for: .normal)
                button.backgroundColor = UIColor.clear
                button.addTarget(self, action: #selector(accessoryButtonTapped(sender:event:)), for: .touchUpInside)
                itemCell.accessoryView = button
            }
            return itemCell
        case .displayAvailableChoices(let itemsToDisplay), .displaySearchResults(let itemsToDisplay) :
            searchBar.showsCancelButton = true
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            itemCell.itemLabel.text = itemsToDisplay[indexPath.row].name
            itemCell.backgroundColor = cellBackgroundColor
            return itemCell
        }
        
    }
    
    @objc private func accessoryButtonTapped(sender: UIButton, event: UIEvent) {
        print("accessoryButtonTapped")        
        let touches = event.allTouches
        let touch = touches?.first
        if let currentTouchPosition = touch?.location(in: tableView) {
            if let indexPath = tableView.indexPathForRow(at: currentTouchPosition) {
                print("index Path = \(indexPath.row)")
                //pickerView.selectedItemName = selectedItems[indexPath.row].name
                
                // new code create new view controller
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as? PickerViewController else { return }
                
                vc.dataProvider = dataProvider
                
                let pickerOriginX = view.bounds.origin.x + 50
                let pickerOriginY = view.bounds.origin.y + 100
                let pickerWidth = view.bounds.width - 100
                let pickerHeight = view.bounds.height - 200
                
                let pickerFrame = CGRect(x: pickerOriginX, y: pickerOriginY, width: pickerWidth, height: pickerHeight)
                self.add(vc, frame: pickerFrame)
                reloadData()
                
                //pickerView.refresh()
                //pickerView.isHidden = false
                //reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // do not allow to select cell in...
        if searchBarIsEmpty && !searchBarIsInFocus {
            return
        }
        // get the corresponding item and negate the selected status
        let selectedItem: Item
        if searchBarIsEmpty {
            selectedItem = notSelectedItems[indexPath.row]
        } else {
            selectedItem = foundItems[indexPath.row]
        }
        dataProvider.selectItem(withName: selectedItem.name)
        // cancel search
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func setSelection(for cell: ItemCell, withState isSelected: Bool) {
        if !isSelected {
            cell.accessoryType = .none
            cell.itemLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.itemLabel?.textColor = UIColor.gray
        }
    }
}


// MARK: Search Bar Utilities

extension ListViewController {
    
    var searchBarIsEmpty: Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    func searchBarSetup() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Tap to Add Item"
        
        let attributedStringKeys: [NSAttributedStringKey : Any] = [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.underlineStyle : 1]

        barButton.title = ""
        barButton.setTitleTextAttributes(attributedStringKeys, for: .normal)
        barButton.isEnabled = false
        searchBar.returnKeyType = .done
        
        // Create white icon image programatically
        let size = CGSize(width: 24, height: 24)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.white.setFill()
        let rect = CGRect(x: 0, y: 0, width: 24, height: 24)
        UIRectFill(rect)
        let icon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        searchBar.setImage(icon, for: .search, state: .normal)
        //searchBar.searchTextPositionAdjustment = UIOffset(horizontal: -20, vertical: 0)
        //searchBar.scopeButtonTitles = ["Selected Items", "All Items"]
        //searchBar.showsScopeBar = true
        navigationItem.titleView = searchBar
        //navigationItem.title = "Quick List"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar text did change")
// decided not to show the cancel button
//        if isSearchBarEmpty {
//            searchBar.showsCancelButton = false
//        } else {
//            searchBar.showsCancelButton = true
//        }
        searchResults(for: searchText)
        reloadData()
    }
    
    // MARK: Add new item
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarIsInFocus = false
        // if search text not empty then add new item to data provider
        if let text = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            if text != "" {
                dataProvider.newSelectedItem(withName: text)
                searchBar.text = nil
            }
        }
    }

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        
        // show all items when focus goes to searchbar
        searchBarIsInFocus = true
        //foundItems = items
        reloadData()
    }
    
    
    func searchResults(for text: String) {
        foundItems = dataProvider.items.filter({ (item: Item) -> Bool in
            // item name contains search text and item is not already selected
            return item.name.lowercased().contains(text.lowercased()) && !item.isSelected
        })
    }
}
