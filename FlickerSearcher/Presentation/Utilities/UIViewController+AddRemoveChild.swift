//
//  UIViewController+AddRemoveChild.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
