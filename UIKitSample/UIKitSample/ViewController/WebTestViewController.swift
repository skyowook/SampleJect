//
//  WebTestViewController.swift
//  UIKitSample
//
//  Created by skw on 10/28/24.
//

import UIKit
import WebKit

class WebTestViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    var testTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        DispatchQueue.main.async {
            if let url = URL(string: "https://apple.com") {
                let request = URLRequest(url: url)
                self.testTime = Date().timeIntervalSince1970
                self.webView.load(request)
            }
        }
    }

}

extension WebTestViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("==== Speed Test Loaded")
        NSLog("==== Loaded Time \(Date().timeIntervalSince1970 - testTime)")
        
    }
}
