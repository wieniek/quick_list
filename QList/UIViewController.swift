//
//  UIViewController.swift
//  QList
//
//  Created by Home Mac on 4/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect) {
        addChildViewController(child)
        //if let frame = frame {
            child.view.frame = frame
        //}
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    func remove() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
