//
//  Category.swift
//  QList
//
//  Created by Home on 3/19/18.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation
import Firebase

struct Category {
    let key: String
    let ref: DatabaseReference?
    let name: String
    let icon: String
    let order: Int
    
    init() {
        key = ""
        ref = nil
        name = "Other"
        icon = "🛒"
        order = 0
    }
    
    init(name: String, icon: String, order: Int) {
        key = ""
        ref = nil
        self.name = name
        self.icon = icon
        self.order = order
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as? String ?? "Other"
        icon = snapshotValue["icon"] as? String ?? "🛒"
        order = snapshotValue["order"] as? Int ?? 0
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "icon": icon,
            "order": order,
        ]
    }
}
