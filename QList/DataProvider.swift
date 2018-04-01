//
//  DataProvider.swift
//  QList
//
//  Created by Home on 3/10/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import Firebase

protocol DataProviderDelegate {
    func dataProviderDidUpdate()
}

class DataProvider {
    
    var delegate: DataProviderDelegate?
    private lazy var databaseItems = Database.database().reference(withPath: "qlist-items")
    private lazy var databaseCategories = Database.database().reference(withPath: "qlist-categories")
    
    var items = [Item]()
    var categories = [Category]()
    
    // given item name returns its index in the items array
    func indexOfItem(withName name: String) -> Int? {
        let index = items.index { (item: Item) -> Bool in
            return item.name.lowercased() == name.lowercased()
        }
        return index
    }
    
    init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        Auth.auth().signIn(withEmail: "???", password: "???") { (user, error) in
            print("Log in ......... success")
            self.setupListeners()
        }
    }
    
    // Listener setup and initial data pull
    func setupListeners() {
        // Attach asynchronous listener to db reference
        databaseItems.queryOrdered(byChild: "name").observe(.value) { snapshot in
            // Load a local table from snapshot data
            var items = [Item]()
            for item in snapshot.children {
                let listItem = Item(snapshot: item as! DataSnapshot)
                items.append(listItem)
            }
            // replace main items table with data from local table
            self.items = items
            self.delegate?.dataProviderDidUpdate()
        }
        // Retrive categories from Firebase
        databaseCategories.observeSingleEvent(of: .value) { snapshot in
            var categories = [Category]()
            for child in snapshot.children {
                let category = Category(snapshot: child as! DataSnapshot)
                categories.append(category)
            }
            self.categories = categories.sorted(by: { (cat1, cat2) -> Bool in
                cat1.order < cat2.order
            })
        }
    }
    
    // Locate item and permanently remove it from data store
    func removeItem(withName name: String) {
        if let index = self.indexOfItem(withName: name) {
            let listItem = self.items[index]
            listItem.ref?.removeValue()
        }
    }
    
    // Insert new item mareked as selected
    // Use lowercase name as key
    func newSelectedItem(withName name: String) {
        let item = Item(name: name, isSelected: true)
        let itemRef = databaseItems.child(item.name.lowercased())
        itemRef.setValue(item.toAnyObject())
    }
    // Mark item as selected
    func selectItem(withName name: String) {
        if let itemIndex = indexOfItem(withName: name) {
            let listItem = items[itemIndex]
            if !listItem.isSelected {
                listItem.ref?.updateChildValues(["selected" : true])
            }
        }
    }
    // Locate item and update it's properties to be no longer selected
    func deselectItem(withName name: String) {
        if let index = indexOfItem(withName: name) {
            let listItem = items[index]
            listItem.ref?.updateChildValues(["selected" : false, "completed" : false])
        }
    }
    // Remove all selected items from the list
    func deselectAllSelectedItems() {
        let selectedItems = items.filter({ (item: Item) -> Bool in
            return item.isSelected
        })
        for item in selectedItems {
            if let index = indexOfItem(withName: item.name) {
                let listItem = items[index]
                listItem.ref?.updateChildValues(["selected" : false, "completed" : false])
            }
        }
    }
    // Remove all completed items from the selected items list
    func deselectAllCompletedItems() {
        let completedItems = items.filter({ (item: Item) -> Bool in
            return item.isCompleted
        })
        for item in completedItems {
            if let index = indexOfItem(withName: item.name) {
                let listItem = items[index]
                listItem.ref?.updateChildValues(["selected" : false, "completed" : false])
            }
        }
    }
    
    // Update item completed state
    func updateItem(named name: String, completedState state: Bool) {
        if let index = indexOfItem(withName: name) {
            let listItem = items[index]
            listItem.ref?.updateChildValues(["completed" : state])
        }
    }
    
    // Update item category
    func updateItem(named name: String, withCategory category: Category) {
        if let index = indexOfItem(withName: name) {
            let listItem = items[index]
            listItem.ref?.updateChildValues(["category_name" : category.name,
                                             "category_icon" : category.icon,
                                             "category_order" : category.order])
        }
    }
    
}
