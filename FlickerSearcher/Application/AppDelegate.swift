//
//  AppDelegate.swift
//  FlickrSearcher
//
//  Created by Amir Abbas Kashani on 11/5/19.
//  Copyright © 2019 aakpro. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    let appDIContainer = AppDIContainer()
    var window: UIWindow?
    
    /// Setup appearance and make the first view controller
    /// - Parameter application: current application
    /// - Parameter launchOptions: launch options passed to app
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppAppearance.setupAppearance()
        window = UIWindow(frame: UIScreen.main.bounds)
        let photosListViewController = appDIContainer.makePhotosSceneDIContainer().makePhotosListViewController()
        let navigationController = UINavigationController(rootViewController: photosListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

