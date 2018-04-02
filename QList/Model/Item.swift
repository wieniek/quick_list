//
//  Item.swift
//  QList
//
//  Created by Home on 1/21/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import Firebase

struct Item {
    let key: String
    let ref: DatabaseReference?
    let name: String
    let addedBy: String
    var isSelected: Bool
    var isCompleted: Bool
    var category: Category
    
    init(name: String) {
        key = ""
        ref = nil
        self.name = name
        addedBy = "user@domain.com"
        isSelected = false
        isCompleted = false
        self.category = Category()
    }
    
    init(name: String, isSelected: Bool) {
        self.key = ""
        self.ref = nil
        self.name = name
        self.addedBy = "user@domain.com"
        self.isSelected = isSelected
        self.isCompleted = false
        self.category = Category()
    }
    
    init(name: String, isCompleted: Bool) {
        self.key = ""
        self.ref = nil
        self.name = name
        self.addedBy = "user@domain.com"
        self.isSelected = false
        self.isCompleted = isCompleted
        self.category = Category()
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedBy = snapshotValue["addedBy"] as! String
        isSelected = snapshotValue["selected"] as! Bool
        isCompleted = snapshotValue["completed"] as! Bool
        let category_name = snapshotValue["category_name"] as? String
        let category_icon = snapshotValue["category_icon"] as? String
        let category_order = snapshotValue["category_order"] as? Int
        if let category_name = category_name,
            let category_icon = category_icon,
            let category_order = category_order {
            category = Category(name: category_name, icon: category_icon, order: category_order)
        } else {
            category = Category()
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedBy": addedBy,
            "selected": isSelected,
            "completed": isCompleted,
            "category_name": category.name,
            "category_icon": category.icon,
            "category_order": category.order
        ]
    }
}
