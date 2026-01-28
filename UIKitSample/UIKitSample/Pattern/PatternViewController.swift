//
//  PatternViewController.swift
//  UIKitSample
//
//  Created by skw on 2/13/25.
//

import UIKit
import BloomUIKit

/// 패턴 컨트롤러
class PatternViewController: BottomPopupController {
    // MARK: - Property
    @IBOutlet private weak var patternView: PatternView!
    
    private var resetButton: UIButton!
    private var pattern: String = "01234"

    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PatternView 생성 및 설정
        patternView.backgroundColor = .lightGray
        patternView.delegate = self
    }
    
    @objc private func verifyPattern() {
        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Pattern Verification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func ignoreDismissTouchViews() -> [UIView]? {
        return [patternView]
    }
}

extension PatternViewController: PatternViewDelegate {
    func patternView(_ view: PatternView, pattern: String) {
        if patternView.getPattern() == self.pattern {
            showAlert(message: "Pattern is correct!")
        } else {
            showAlert(message: "Pattern is incorrect.")
        }
    }
}
