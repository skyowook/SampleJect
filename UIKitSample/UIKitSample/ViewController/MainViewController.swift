//
//  MainViewController.swift
//  UIKitSample
//
//  Created by skw on 2/13/25.
//

import UIKit

/// 메인 테스트용
class MainViewController: UIViewController {
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("didLoad")
    }
    
    // MARK: - Action Func
    @IBAction private func touchTestButton(_ sender: UIButton) {
        PatternViewController.openPattern(from: self)
    }
}
