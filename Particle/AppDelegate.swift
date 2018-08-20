//
//  AppDelegate.swift
//  Particle
//
//  Created by Artem Misesin on 6/25/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if
            let window = window,
            let root = window.rootViewController as? UITabBarController,
            let viewControllers = root.viewControllers,
            let splitViewController = viewControllers[0] as? UISplitViewController {
            splitViewController.delegate = self
        }
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
//        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//        guard let topAsDetailController = secondaryAsNavController.topViewController as? ReaderViewController else { return false }
//        if topAsDetailController.detailItem == nil {
//            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//            return true
//        }
        return true
    }
    
}
