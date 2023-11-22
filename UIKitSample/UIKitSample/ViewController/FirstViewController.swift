//
//  File.swift
//  UIKitSample
//
//  Created by skw on 10/10/23.
//

import IAssistKit
import UIKit
import Alamofire
import WebKit

class FirstViewController : IAViewController {
    var sessionManager: Session?
    @IBOutlet private weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let certificates = [
                "smart.kisb.co.kr":
                    PinnedCertificatesTrustEvaluator(certificates: [SecCertificate.loadCertificate("test")!],
                                                     acceptSelfSignedCertificates: false,
                                                     performDefaultValidation: true,
                                                     validateHost: true)]

        let serverTrustPolicy = ServerTrustManager(
                        allHostsMustBeEvaluated: true,
                        evaluators: certificates)
        
        sessionManager = Session(serverTrustManager: serverTrustPolicy)

        let url = URL(string: "https://smart.kisb.co.kr")
        webview.navigationDelegate = self
        
        webview.load(URLRequest(url: url!))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAppUpdate()
    }
    
    func getAppUpdate() {
        let baseUrl = "https://smart.kisb.co.kr"
        let url = "\(baseUrl)/APP010000001.pwkjson"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let trimString = "Content-Type".replacingOccurrences(of: " ", with: "") //2023.07.05 보안취약
        request.setValue("application/json", forHTTPHeaderField: trimString)
        request.timeoutInterval = 10
        
        let params = ["elData":["REQ_DATA":["OS":"IOS"]]] as Dictionary
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            sessionManager?.request(request).validate(statusCode: 200..<300).responseString { (response) in
                switch response.result {
                case .success:
                    if let json = response.data {
                        let dicJson = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
                        debugPrint(dicJson ?? [:])
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        } catch {
            debugPrint("try error")
        }
    }
}

extension FirstViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let file = Bundle.main.path(forResource: "test", ofType: "cer"), let clientCert = NSData(contentsOfFile: file) {
            if challenge.checkSSLPinning(with: clientCert) {
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            }
        }
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}
