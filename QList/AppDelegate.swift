//
//  AppDelegate.swift
//  QList
//
//  Created by Home on 1/21/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Firebase initial data set
//    var categories = [Category(name: "Bakery", icon: "🥖", order: 1),
//                      Category(name: "Frozen", icon: "🍦", order: 7),
//                      Category(name: "Baking", icon: "🍪", order: 5),
//                      Category(name: "Dairy", icon: "🥛", order: 2),
//                      Category(name: "Meat", icon: "🍗", order: 4),
//                      Category(name: "Cooking", icon: "👩🏻‍🍳", order: 6),
//                      Category(name: "Deli", icon: "🥓", order: 3),
//                      Category(name: "Produce", icon: "🍏", order: 9),
//                      Category(name: "Household", icon: "🏡", order: 10),
//                      Category(name: "Snack", icon: "🍿", order: 8),
//                      Category(name: "Other", icon: "🛒", order: 0)]
//
//    var items = [Item(name: "Apples"),
//                 Item(name: "Chicken"),
//                 Item(name: "Coffee"),
//                 Item(name: "Corn"),
//                 Item(name: "Cranberries"),
//                 Item(name: "Bacon"),
//                 Item(name: "Bagels"),
//                 Item(name: "Bananas"),
//                 Item(name: "Bread"),
//                 Item(name: "Butter"),
//                 Item(name: "Eggs"),
//                 Item(name: "Flour"),
//                 Item(name: "Ginger"),
//                 Item(name: "Lemon"),
//                 Item(name: "Mayo"),
//                 Item(name: "Milk"),
//                 Item(name: "Pastry"),
//                 Item(name: "Popcorn"),
//                 Item(name: "Potatoes"),
//                 Item(name: "Salmon"),
//                 Item(name: "Sugar"),
//                 Item(name: "Spinach"),
//                 Item(name: "Steak"),
//                 Item(name: "Turkey"),
//                 Item(name: "Wine"),
//                 Item(name: "Vinegar"),
//                 Item(name: "Yogurt"),]


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.black
        
        let dataProvider = DataProvider()
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            let listViewController = navigationController.viewControllers.first as? ListViewController
            listViewController?.dataProvider = dataProvider
        }
        
        // Setup Firebase
        // FirebaseApp.configure()
        
//        // Save all items to Firebase database
//        let databaseRef1 = Database.database().reference(withPath: "qlist-items")
//        for listItem in items {
//            let listItemRef = databaseRef1.child(listItem.name.lowercased())
//            listItemRef.setValue(listItem.toAnyObject())
//        }
//
//        // Save all items to Firebase database
//        let databaseRef2 = Database.database().reference(withPath: "qlist-categories")
//        for category in categories {
//            let categoryRef = databaseRef2.child(category.name.lowercased())
//            categoryRef.setValue(category.toAnyObject())
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

