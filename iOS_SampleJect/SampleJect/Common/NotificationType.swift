//
//  NotificationType.swift
//  SampleJect
//
//  Created by ben on 2022/09/01.
//  Copyright © 2022 SinKyoUk. All rights reserved.
//

import Foundation

/// Notification Center Type
enum NotificationType: String {
    case willEnterForeground = "willEnterForeground"
    case didEnterBackground = "didEnterBackground"
    case didChangedAccessToken = "didChangedAccessToken"
    
    func post(with object: Any?) {
        NotificationCenter.default.post(name: Notification.Name(self.rawValue), object: object)
    }
    
    func registerObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(self.rawValue), object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(self.rawValue), object: nil)
    }
}
