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

/// 테스트용으로 만든 데이터 모델 Pem의 old인증서와 new인증서 데이터를 파싱해서 사용한다.
class PemCertificateModel: Decodable {
    var old: String
    var new: String
}

// SSL Pinning 테스트 뷰
class SslPinningViewController : IAViewController {
    @IBOutlet private weak var webview: WKWebView!
    @IBOutlet private weak var certificateSwitch: UISwitch!

    private var sessionManager: Session?
    private var certificates: [SecCertificate] = []
    private var certificateModel: PemCertificateModel?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        requestCertificateData()
    }

    private func initCertificate(_ pemString: String) {
        // Api통신에 사용될 Session을 만들기위한 Certificate 생성
        certificates = SecCertificate.createCertificatesForPem(pemString)
        let pinnedCertificates = PinnedCertificatesTrustEvaluator(certificates: certificates)
        let certificates = [
                "smart.kisb.co.kr" : pinnedCertificates
        ]

        // Alamofire Session 생성
        let serverTrustPolicy = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: certificates)
        sessionManager = Session(serverTrustManager: serverTrustPolicy)
    }
    
    private func requestCertificateData() {
        let urlString: URLConvertible = "https://hosting-4e3b6.web.app/certificate_test.json"
        AF.request(urlString, method: .post)
            .responseDecodable(of: PemCertificateModel.self, completionHandler: { response in
                switch response.result {
                case .success(let model):
                    print(
                    """
                    ======= CERTIFICATE_NEW
                    \(model.new)
                    ======= CERTIFICATE_OLD
                    \(model.old)
                    """
                    )
                    self.certificateModel = model
                    self.initCertificate(model.new)
                    self.certificateSwitch.isOn = true
                case .failure(let error):
                    debugPrint("Error :: \(error.localizedDescription)")
                }
            })
    }

    @IBAction private func changeSwitch(_ sender: UISwitch) {
        guard let model = certificateModel else { return }
        if sender.isOn {
            initCertificate(model.new)
        } else {
            initCertificate(model.old)
        }
    }

    /// 웹 로드 버튼 터치
    @IBAction private func touchLoadWebBtn(_ sender: UIButton) {
        // SslPinning이 필요한 사이트 접근을 위한 테스트
        let url = URL(string: "https://smart.kisb.co.kr")
//        let url = URL(string: "https://m.naver.com")
        webview.navigationDelegate = self
        webview.load(URLRequest(url: url!))
    }

    /// Ssl Api 테스트 함수
    @IBAction private func testSslPinningApi(sender: UIButton) {
        let baseUrl = "https://smart.kisb.co.kr"
        let url = "\(baseUrl)/APP010000001.pwkjson"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let trimString = "Content-Type".replacingOccurrences(of: " ", with: "") // 2023.07.05 보안취약
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
    private func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        // - Host 체크 들어가야함. (해당 URL이 포함될 때 SSL Pinning 진행)
        if challenge.protectionSpace.host.contains("smart.kisb.co.kr") {
            do {
                let evaluator = PinnedCertificatesTrustEvaluator(certificates: certificates)
                let loadedHost = challenge.protectionSpace.host
                
                try evaluator.evaluate(serverTrust, forHost: loadedHost)
                
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
            } catch {
                debugPrint(error.localizedDescription)
                completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
