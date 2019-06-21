//
//  WKWebViewTestController.swift
//  TestProject
//
//  Created by IMC056 on 2018. 10. 29..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit
import WebKit

/// WKWebView에 대한 각종 기능을 테스트하는 샘플
class WKWebViewTestController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var urlTextView: UITextView!
    
    private var isSSLErrorContinue: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        // 네이티브 스크립트를 제공해주기 위한 컨트롤러
        let contentController = WKUserContentController()
        contentController.add(self, name: "CoochaClient")
        
        webView.configuration.userContentController.add(self, name: "CoochaClient")
        webView.configuration.userContentController.add(self, name: "CoochaClient2")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action Func
    /// 일반 웹 로드
    @IBAction private func touchReloadButton(_ sender: AnyObject) {
        loadWeb()
    }
    
    /// html 로드 - 네이티브 스크립트 테스트를 위함
    @IBAction private func touchHtmlLoadButton(_ sender: AnyObject) {
        let htmlString = "<html><head><script type=\"text/javascript\" charset=\"UTF-8\"> function callNative() { console.log(\"adf\"); try{ window.webkit.messageHandlers.CoochaClient2.postMessage({did: '입력값', sid:'입력값', shopName:'입력값', url : '입력값' }); } catch(err) {console.log(err); } } </script> </head> <body> <input type=\"button\" onclick=\"callNative()\" value=\"네이티브\" /> </body> </html>"
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    // MARK: - Private Func
    fileprivate func showCertificateAlert() {
        let alertController = UIAlertController(title: nil, message: "신뢰하지 않은 인증서입니다.\n계속 진행하시겠습니까?", preferredStyle: .alert)
        let connectButtonAction = UIAlertAction(title: "연결", style: .default) { (action) in
            self.isSSLErrorContinue = true
            
            self.loadWeb()
        }
        
        let cancelButtonAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(connectButtonAction)
        alertController.addAction(cancelButtonAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// 웹페이지 로드
    fileprivate func loadWeb() {
        let urlRequest: URLRequest! = URLRequest(url: URL(string: "https://www.naver.com")!)
        
        webView.load(urlRequest)
    }
}

// MARK: - WKNavigationDelegate
extension WKWebViewTestController: WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        debugPrint("did Receive :::: \(challenge.protectionSpace.authenticationMethod)")
        
        if isSSLErrorContinue {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
            return
        }
        
        completionHandler(.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("didFail ::::\(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("didFinish")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint("didNavigationAction")
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        debugPrint("didNavigationResponse")
        
        if let response = navigationResponse.response.isKind(of: HTTPURLResponse.classForCoder()) as? HTTPURLResponse {
            debugPrint("Code ::: \(response.statusCode)")
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint("didFailProvisional \(error.localizedDescription)")
        
        guard let urlError = error as? URLError else { return }
   
        switch urlError.code {
        case URLError.Code.clientCertificateRejected, URLError.Code.clientCertificateRequired, URLError.Code.serverCertificateUntrusted,
             URLError.Code.serverCertificateHasBadDate, URLError.Code.serverCertificateNotYetValid, URLError.Code.serverCertificateHasUnknownRoot:
            debugPrint("URL Certificate Error")
            showCertificateAlert()
            break
        default:
            break
        }
    }
    
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let values: [String: String] = message.body as! Dictionary
        debugPrint("here???")
    }
}
