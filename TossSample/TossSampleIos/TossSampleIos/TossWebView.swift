//
//  TossWebView.swift
//  TossSampleIos
//
//  Created by skw on 8/23/23.
//

import WebKit
import Alamofire

class TossWebView: WKWebView {
    private let ON_LOADED = "TOSS_AUTH_POPUP_ONLOAD"
    private let AUTH_SUCCESS = "TOSS_AUTH_SUCCESS"
    private let AUTH_FAIL = "TOSS_AUTH_FAIL"
    private let AUTH_CANCEL = "TOSS_AUTH_CLICK_NAVBAR_CLOSE"
    
    private let contentController = WKUserContentController()
    
    private var authorization = ""
    private var txID: String = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        super.init(frame: frame, configuration: configuration)
        
        contentController.add(self, name: "tossAuthWebView")
        self.navigationDelegate = self
    }
    
    // MARK: - Public Func
    func load() {
        requestAccessToken()
    }
    
    // MARK: - Private Func
    private func loadToss(_ txID: String, _ authURLString: String) {
        guard let url = URL(string: authURLString) else { return }

        // 1. 토스인증 표준창 실행하기 전에 request를 아래와 같이 생성한 후에
        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = "txId=\(txID)".data(using: .utf8)

        // 2. 만들어진 request를 이용해 웹뷰를 실행해주세요. 애플이 제공하는 웹뷰 호출 기본 함수입니다.
        load(request)
    }
    
    // MARK: - Request
    private func requestAccessToken() {
        if let authorization = UserDefaults.standard.string(forKey: "authorization") {
            self.requestSignAuthInfo(authorization)
            return
        }
        
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : AppConstants.TOSS_CLIENT_ID,
            "client_secret" : AppConstants.TOSS_CLIENT_SECRET,
            "scope" : "ca"
        ]

        let url = "\(AppConstants.TOSS_OAUTH_SERVER)/token"
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).responseDecodable(of : TossTokenRes.self) { response in
            switch response.result {
            case .success(let data):
                if let tokenType = data.tokenType, let token = data.token {
                    let authorization = "\(tokenType) \(token)"
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(authorization, forKey: "authorization")
                    userDefaults.synchronize()
                    self.requestSignAuthInfo(authorization)
                } else {
                    // TODO: 에러처리
                }
            case .failure(let error):
                debugPrint(error.errorDescription ?? "")
                // TODO: 에러처리
            }
        }
    }
    
    private func requestSignAuthInfo(_ authorization: String) {
        let params = [
            "requestType" : "USER_NONE"
        ]
        
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: authorization)
        
        let url = "\(AppConstants.TOSS_API_SERVER)/api/v2/sign/user/auth/id/request"
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of : TossApiRes<TossSignAuthInfo>.self) { response in
            switch response.result {
            case .success(let data):
                if let url = data.success?.authUrl, let txId = data.success?.txId {
                    self.txID = txId
                    self.authorization = authorization
                    self.loadToss(txId, url)
                } else {
                    // TODO: 에러처리
                }
            case .failure(let error):
                debugPrint(error.errorDescription ?? "")
                // TODO: 에러처리
            }
        }
    }
    
    let sessionKey = "v1_0.0.11$3cafedae-c1a3-4f43-b248-d0b10d98011c$W8jpHYIhhDi8zN3xoM+fK/h/ntHznTP1PZ3TXp4wtKOGP3d4AUYB6jOO7Pt7Vd853e2MXzVQVT5fqYX1lO0pk3pvV6TXCw3m0ybIeSx9QdciePemWKiZNJK11EmNPKGkm5YJqyQ7yBugoBYzBqNVl85SLnGuA48YB9yyC2FvtkSlQXiraBdxSnPWqkLxd4/J3wK23xguv0dz1A9rzwwsPtxfk0OVCncGM1p8sNuUYcQpvxA+7HIeWHuAzahEef6kb+cr5Q9J8qQ5kxXVfz6zll4aAp48JbrxbyyGVnXe1MPorGw18gqTQfN5kEX43sRnt7uhiRqYnRKxXOZFaq5JsPnTpSTTS6heiPg2Nk3AOxE7vAqlKbK2fulcls2r+MqGLsyboX5vbeRYw7BwQaVFuw80ffoHpP53vs0hNpoXN9Gj4YLt834tvZuhTyoRddvn0sO+W0GrufnMNZ0ojPF5HBJqefegsAFIuQqCsIrp57jMh3523o/aOf6cJq4DvzGw+asNPnNWpOClzvydj58n8hYVBhdqUbsqEzvjIfEYwfZaeKKUMKvYWrTS6nd6Ko5ruqAoxSHRDxUCz5Spz2P98QSwhgVnGfp4Le8dwVLakhdrauwelawCaeHpHnfaV/dF3GPz8qoS62yQ8k4yDsq9WbmsD7RlDPAZ3JUttBaCX7w="
    
    private func requestSignAuthResult(_ authorization: String) {
        let session = TossCertSessionGenerator().generate()
        debugPrint(session.sessionKey)
        let params = [
            "txId" : self.txID,
            "sessionKey" : session.sessionKey
        ]
        
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: authorization)
        let url = "\(AppConstants.TOSS_API_SERVER)/api/v2/sign/user/auth/id/result"
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of : TossApiRes<TossSignAuthResult>.self) { response in
            switch response.result {
            case .success(let data):
                debugPrint("과연??")
//                debugPrint(self.testDecrypt(data.success?.personalData?.name ?? ""))
//                debugPrint(session.decrypt(data.success?.personalData?.name ?? "") ?? "")
            case .failure(let error):
                debugPrint(error.errorDescription ?? "")
                // TODO: 에러처리
            }
        }
    }
    
    /// AES Cipher까진 정상 동작 확인 완료
    /// Android에서 생성한 SessionKey와 secretKey, Iv를 활용한 복호화는 성공
    private func testDecrypt(_ encrypted: String) -> String? {
        let cipher = AESCipher("RgmEkDlZYMIfBa9BQlC9l36FlzG5X9Vz+3ZK6yyLPZg=", "4efcrC76ZCwrt+pT")
        let result = cipher.decrypt(encrypted.components(separatedBy: "$")[2])
        return result
    }
}

extension TossWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, (url.scheme == "itms-appss" || url.host == "ul.toss.im") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
    }
}

extension TossWebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let body = message.body as? String else { return }

            switch body {
            case ON_LOADED: // 표준창 로드 완료
                debugPrint("Toss page onloaded")
            case AUTH_SUCCESS: // 표준창 완료
                debugPrint("Toss auth success")
                requestSignAuthResult(self.authorization)
            case AUTH_FAIL: // 표준창 에러
                debugPrint("Toss auth fail")
            case AUTH_CANCEL: // 취소
                debugPrint("Toss auth cancel")
            default:
                break
            }
        }
}
