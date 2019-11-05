//
//  Alertable.swift
//  FlickrSearcher
//
//  Created by Amir Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit

/// shows alert
public protocol Alertable {}

public extension Alertable where Self: UIViewController {
    
    /// Show alert controller
    /// - Parameter title: title of alert
    /// - Parameter message: message of allert
    /// - Parameter preferredStyle: style
    /// - Parameter completion: callback when action is done
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
