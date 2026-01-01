//
//  SceneDelegate.swift
//  UIKitSample
//
//  Created by skw on 10/10/23.
//

import UIKit
import IACoreKit

class SceneDelegate: IASceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its sessio/.n was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // userActivity.activityType이 NSUserActivityTypeBrowsingWeb이어야 Universal Link입니다.
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let incomingURL = userActivity.webpageURL {
            NSLog("test ::: sceneDelegate ::: \(incomingURL.absoluteString)")
        }
    }
}
