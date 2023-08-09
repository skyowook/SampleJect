//
//  ViewController.swift
//  LoginTest
//
//  Created by ben on 2020/04/06.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchAuthorizationAppleIDButton(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Web 호출
            let controller = RN_AppleLoginWebViewController(nibName: "RN_AppleLoginWebViewController", bundle: nil)
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    @available (iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @available (iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            
            debugPrint("identifier : \(userIdentifier) email : \(email ?? "")")
        }
    }

    @available (iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

extension ViewController: RN_AppleLoginWebViewDelegate {
    func loginAppleData(_ model: RN_AppleLoginModel) {
        debugPrint("apple id identifier ::: " + model.identifier!)
        debugPrint("apple email identifier ::: " + model.email!)
    }
}
