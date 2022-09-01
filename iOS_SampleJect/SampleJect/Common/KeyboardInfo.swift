//
//  KeyboardInfo.swift
//  SampleJect
//
//  Created by ben on 2022/09/01.
//  Copyright © 2022 SinKyoUk. All rights reserved.
//

import Foundation
import UIKit

/// 키보드 정보 구조체
struct KeyboardInfo {
    var height: CGFloat
    var duration: TimeInterval
    var curve: UIView.AnimationCurve
    
    init(height: CGFloat, duration: TimeInterval, curve: UIView.AnimationCurve = .easeInOut) {
        self.height = height
        self.duration = duration
        self.curve = curve
    }
    
    init(_ notification: Notification) {
        let info = notification.userInfo
        let kbSize = (info?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let duration = (info?[UIWindow.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        let animationCurve = UIView.AnimationCurve(rawValue: (info?[UIWindow.keyboardAnimationCurveUserInfoKey] as? Int) ?? 0)
        
        self.height = kbSize?.height ?? 0
        self.duration = duration ?? 0
        self.curve = animationCurve ?? .easeInOut
    }
}
