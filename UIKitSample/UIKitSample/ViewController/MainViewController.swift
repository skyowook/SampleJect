//
//  MainViewController.swift
//  UIKitSample
//
//  Created by skw on 2/13/25.
//

import UIKit
import BloomUIKit

/// 메인 테스트용
class MainViewController: UIViewController {
    @IBOutlet private weak var clipboardLabel: UILabel!
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()

        // UUID Test
        debugPrint(CFUUIDCreateString(nil, CFUUIDCreate(nil))! as String)
        
        clipboardLabel.text = UIPasteboard.general.string ?? "clipboard is nil"
        UIPasteboard.general.string = nil
    }
    
    // MARK: - Action Func
    @IBAction private func touchTestButton(_ sender: UIButton) {
        FindAddressViewController.open(from: self) { result in
            debugPrint(result)
        }
        
//        PatternViewController.open(from: self)
    }
    
    @IBAction private func touchUniversalLink(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://hosting-4e3b6.firebaseapp.com")!)
    }
}
 

