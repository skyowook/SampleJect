//
//  AppDelegate.swift
//  UIKitSample
//
//  Created by skw on 10/10/23.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // PR테스트를 위한 수정 - duplicateTest 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 앱 종료 상태에서 universalLink로 진입시
        if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [String: Any],
           let userActivity = userActivityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL {
            NSLog("test ::: appDelegate ::: \(incomingURL.absoluteString)")
        }
        
        // spotlight test
        
        DispatchQueue.global(qos: .background).async {
            let attributeSet = CSSearchableItemAttributeSet(contentType: .data)
            attributeSet.displayName = "test"
            attributeSet.title = "테스트 이 저기 여기"
            attributeSet.contentDescription = "테스트 이 저기 여기 설명"
            attributeSet.keywords = ["이", "저기", "여기"]
            attributeSet.thumbnailData = UIImage(named: "AppIcon")?.pngData()
            
            let item = CSSearchableItem(uniqueIdentifier: "UIKitSample", domainIdentifier: "com.skw", attributeSet: attributeSet)
            CSSearchableIndex.default().indexSearchableItems([item]) { error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    debugPrint("인덱싱 성공")
                }
            }
        }
        // --end
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
//    ====
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        debugPrint("test ::: appDelegate ::: \(url.absoluteString)")
        return true
    }
}
