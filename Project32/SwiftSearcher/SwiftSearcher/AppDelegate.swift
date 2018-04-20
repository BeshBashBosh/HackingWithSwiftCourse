//
//  AppDelegate.swift
//  SwiftSearcher
//
//  Created by Ben Hall on 19/04/2018.
//  Copyright © 2018 BeshBashBosh. All rights reserved.
//

import UIKit
import CoreSpotlight // So we can interact with spotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // This is called when responding to a deep link (ie user entering app from spotlight search)
    // Called after app has finished launching
    // continue userActivity tells us where the deep-link has come from and thus how to respond in the app.
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        // check to see if we have come from spotlight index click
        if userActivity.activityType == CSSearchableItemActionType {
            // Grab the unique identifier stored in the spotlight index item
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                // Do some VC juggling to load user into favorited project straight away
                if let navController = window?.rootViewController as? UINavigationController { // Gets the nav controller
                    if let viewController = navController.topViewController as? ViewController { // get the VC on the top stack of the nav controller (this will be out TableView
                        viewController.showTutorial(Int(uniqueIdentifier)!) // call vc's showTutorial(which:) method to go straight to its SafariVC
                    }
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

