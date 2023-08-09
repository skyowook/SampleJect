//
//  RN_AppleLoginWebViewController.swift
//  LoginTest
//
//  Created by ben on 2020/04/09.
//  Copyright © 2020 Ben. All rights reserved.
//

import UIKit
import WebKit

protocol RN_AppleLoginWebViewDelegate : NSObjectProtocol {
    func loginAppleData(_ model: RN_AppleLoginModel)
}

class RN_AppleLoginWebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    weak var delegate: RN_AppleLoginWebViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        let url = URL(string: "https://hosting-8b8e3.web.app/")
//        let url = URL(string: "http://localhost:5000/test.html")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        
    }
}

extension RN_AppleLoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let path = navigationAction.request.url?.path, path.contains("/api1/callback") {
            webView.isHidden = true
        }
        
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("Finish")
        
        guard let path = webView.url?.path, path.contains("/api1/callback") else { return }
        webView.evaluateJavaScript("document.getElementsByTagName('pre')[0].innerHTML", completionHandler: { (res, error) in
            let jsonDecode = JSONDecoder()
            if let jsonString = res as? String, let delegate = self.delegate,
                let model = try? jsonDecode.decode(RN_AppleLoginModel.self, from: jsonString.data(using: .utf8)!) {
                delegate.loginAppleData(model)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}

