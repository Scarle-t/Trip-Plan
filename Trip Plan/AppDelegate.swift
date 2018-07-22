//
//  AppDelegate.swift
//  Trip Plan
//
//  Created by Scarlet on 18/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVc = self.window?.rootViewController as! UITabBarController
        
        let mynVC = storyboard.instantiateViewController(withIdentifier: "NaviView") as! UINavigationController
        
        let catVC = storyboard.instantiateViewController(withIdentifier: "NaviCategory") as! UINavigationController
        
        let searchVC = storyboard.instantiateViewController(withIdentifier: "NaviSearch") as! UINavigationController
        
//        let calcVc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        if shortcutItem.type == "net.scarletsc.Trip-Plan.Trending" {
            
            tabVc.viewControllers = [mynVC, catVC, searchVC]
            tabVc.selectedViewController = mynVC
            self.window?.makeKeyAndVisible()
            
        }
        
        if shortcutItem.type == "net.scarletsc.Trip-Plan.Category" {
            tabVc.viewControllers = [mynVC, catVC, searchVC]
            tabVc.selectedViewController = catVC
            self.window?.makeKeyAndVisible()
        }
        
        if shortcutItem.type == "net.scarletsc.Trip-Plan.Search"{
            tabVc.viewControllers = [mynVC, catVC, searchVC]
            tabVc.selectedViewController = searchVC
            self.window?.makeKeyAndVisible()
        }
        
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
        
    }


}

