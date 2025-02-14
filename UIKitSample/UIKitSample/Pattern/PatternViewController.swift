//
//  PatternViewController.swift
//  UIKitSample
//
//  Created by skw on 2/13/25.
//

import UIKit
import IAssistKit

/// 패턴 컨트롤러
class PatternViewController: UIViewController {
    // MARK: - Property
    @IBOutlet private weak var patternView: PatternView!
//    @IBOutlet private weak var patternSecondView: PatternView!
    
    private var resetButton: UIButton!
    private var pattern: String = "01234"
    
    // MARK: - Class Func
    class func openPattern(from controller: UIViewController) {
        let patternController = PatternViewController.createOfNib()
        patternController.modalPresentationStyle = .fullScreen
//        patternController.view.layer.speed = 0.1
        controller.present(patternController, animated: true)
    }

    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // PatternView 생성 및 설정
        patternView.backgroundColor = .lightGray
    }
    
    @objc private func resetPattern() {
        patternView.resetPattern()
    }
    
    @objc private func verifyPattern() {
        if patternView.getPattern() == pattern {
            showAlert(message: "Pattern is correct!")
        } else {
            showAlert(message: "Pattern is incorrect.")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Pattern Verification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

