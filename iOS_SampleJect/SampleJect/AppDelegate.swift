//
//  AppDelegate.swift
//  TestProject
//
//  Created by SinKyoUk on 2018. 3. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if self.window?.rootViewController == nil {
            self.window?.rootViewController = UIViewController()
        }
        
        // Add ShortCut (3D Touch)
        if launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem != nil {
            // 호출 타이밍이 어떻게 되는지 확인 필요
            let alert = UIAlertController(title: "Test", message: "ShortCutItem is not empty", preferredStyle: .alert)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            return false
        }
        
        let alert = UIAlertController(title: "Test", message: "ShortCutItem is not empty", preferredStyle: .alert)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        // 숏컷 아이템이 없으면 숏컷 추가
        if let shortcutItems = application.shortcutItems, shortcutItems.isEmpty {
            let shortcutInfo1 = ["testInfo" : "shortcut1"]
            let shortcut1 = UIMutableApplicationShortcutItem(type: "shortcutType1", localizedTitle: "Title", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .audio), userInfo: shortcutInfo1)
            
            application.shortcutItems = [shortcut1]
            
            debugPrint("ShortCut Init")
        }
        
        
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
        
    }
}
