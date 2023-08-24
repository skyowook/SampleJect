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
            case AUTH_FAIL: // 표준창 에러
                debugPrint("Toss auth fail")
            case AUTH_CANCEL: // 취소
                debugPrint("Toss auth cancel")
            default:
                break
            }
        }
}
