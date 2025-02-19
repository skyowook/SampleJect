//
//  MainViewController.swift
//  UIKitSample
//
//  Created by skw on 2/13/25.
//

import UIKit
import IAssistKit

/// 메인 테스트용
class MainViewController: UIViewController {
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action Func
    @IBAction private func touchTestButton(_ sender: UIButton) {
        FindAddressViewController.open(from: self) { result in
            debugPrint(result)
        }
//        PatternViewController.open(from: self)
    }
}
