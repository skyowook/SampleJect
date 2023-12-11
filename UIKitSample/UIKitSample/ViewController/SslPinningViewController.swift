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

// SSL Pinning 테스트 뷰
class SslPinningViewController : IAViewController {
    var sessionManager: Session?
    @IBOutlet private weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Api통신에 사용될 Session을 만들기위한 Certificate 생성
        let secCertificate = SecCertificate.loadCertificate("test")!
        let pinnedCertificates = PinnedCertificatesTrustEvaluator(certificates: [secCertificate])
        let certificates = [
                "smart.kisb.co.kr" : pinnedCertificates
        ]

        // Alamofire Session 생성
        let serverTrustPolicy = ServerTrustManager(allHostsMustBeEvaluated: true, evaluators: certificates)
        sessionManager = Session(serverTrustManager: serverTrustPolicy)

        // SslPinning이 필요한 사이트 접근을 위한 테스트
        let url = URL(string: "https://smart.kisb.co.kr")
        webview.navigationDelegate = self
        webview.load(URLRequest(url: url!))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// Ssl Api 테스트 함수
    @IBAction private func testSslPinningApi(sender: UIButton) {
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

extension SslPinningViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // 인증서 로딩 후 체크
        if let file = Bundle.main.path(forResource: "test", ofType: "cer"), let clientCert = NSData(contentsOfFile: file) {
            if challenge.checkSSLPinning(with: clientCert) {
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
                return
            }
        }
        
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}
