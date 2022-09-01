//
//  BaseHostingViewController.swift
//  SampleJect
//
//  Created by ben on 2022/09/01.
//  Copyright © 2022 SinKyoUk. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class BaseHostingViewController<Content>: UIHostingController<Content> where Content: View {
    // MARK: - Variable
    var isUseCheckKeyboard: Bool {
        return false
    }
    
    var isTouchEndEditing: Bool = false
    
    var keyboardMovePercent: CGFloat? {
        return nil
    }
    
    var originFrame = CGRect.zero
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isUseCheckKeyboard {
            // #. 키보드 온/오프 노티 등록
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIWindow.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidBeHidden(_:)), name: UIWindow.keyboardDidHideNotification, object: nil)
        }
    }
    
    deinit {
        if self.isUseCheckKeyboard {
            NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidHideNotification, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationType.willEnterForeground.registerObserver(self, selector: #selector(willEnterForeground(_:)))
        NotificationType.didEnterBackground.registerObserver(self, selector: #selector(didEnterBackground(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.originFrame == CGRect.zero {
            self.originFrame = self.view.frame
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationType.willEnterForeground.removeObserver(self)
        NotificationType.didEnterBackground.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isTouchEndEditing {
            self.view.endEditing(true)
        }
    }
    
    // MARK: - Public Func
    ///키보드 사용시 키보드 오픈 호출
    func willShowKeyboard(info: KeyboardInfo) {
        guard let percent = keyboardMovePercent else { return }
        let changeValue = info.height * percent
        
        UIView.animate(withDuration: info.duration) {
            var changeFrame = self.originFrame
            changeFrame.origin.y -= changeValue
            changeFrame.size.height += changeValue
            self.view.frame = changeFrame
            self.view.layoutIfNeeded()
        }
    }
    
    func didShowKeyboard(info: KeyboardInfo) {}

    ///키보드 사용시 키보드 클로즈 호출
    func willHideKeyboard(info: KeyboardInfo) {
        guard let _ = keyboardMovePercent else { return }
        
        UIView.animate(withDuration: info.duration) {
            self.view.frame = self.originFrame
            self.view.layoutIfNeeded()
        }
    }
    func didHideKeyboard(info: KeyboardInfo) {}
    
    
    @objc func willEnterForeground(_ notification: Notification) {
        
    }
    
    @objc func didEnterBackground(_ notification: Notification) {
            
        
    }
    
    // MARK: - Action Func
    @IBAction func unwindBack(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func touchBackBtn(_ sender: AnyObject? = nil) {
        performSegue(withIdentifier: UnwindSegueType.unwindBack.rawValue, sender: self)
    }
    
    
    // MARK: - Private Func
    /// 키보드 열림 노티 호출
    @objc private func keyboardWillShow(_ notification: Notification) {
        willShowKeyboard(info: KeyboardInfo(notification))
    }

    /// 키보드 열림 노티 호출
    @objc private func keyboardDidShow(_ notification: Notification) {
        didShowKeyboard(info: KeyboardInfo(notification))
    }
    
    /// 키보드 닫힘 노티 호출
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        willHideKeyboard(info: KeyboardInfo(notification))
    }
    
    /// 키보드 닫힘 노티 호출
    @objc private func keyboardDidBeHidden(_ notification: Notification) {
        didHideKeyboard(info: KeyboardInfo(notification))
    }
}
