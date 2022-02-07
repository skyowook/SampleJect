//
//  ViewController.swift
//  SendNotification
//
//  Created by IMC056 on 2018. 8. 30..
//  Copyright © 2018년 IMC056. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
//    static let APP_IDENTIFIER = "com.sin.test.notifications"
//    let APP_IDENTIFIER = "com.sin.test.notification"
//    let APP_IDENTIFIER = "com.thinkreals.couponmoa"   // 쿠모 식별자
    let APP_IDENTIFIER = "kr.co.couponchart"    // 쿠차 식별자
//    let REG_ID = "58438DAA481AC902A8D92F3FB71A74832BD9A7D486F03EBEE82F85DD0954FD76"
//    let REG_ID = "4382f28607638f3286fc87761cf3252cdb06d487b2621a72e740bfed291f66e6"   // 쿠모 개발 푸시
//    let REG_ID = "94e74ba29b756cc02a4f724d51fda38c33aedaf4b7ed2c4694487e40c403ab86" // 쿠모 운영
    let REG_ID = "923c16bd1075106729ccad22a5883f1f98f4557520ca3c6990739c858a88bcaa" // 쿠차 개발 푸시
                    
    // 쿠차 개발 파일
    let PUSH_CER_FILE = "2020_dev_push_coocha"
    let PUSH_CER_PASS = "1234"
    
    // 쿠폰모아 개발 파일
//    let PUSH_CER_FILE = "2020_dev_push_couponmoa"
//    let PUSH_CER_PASS = "1234"
    // 쿠폰모아 운영 파일
//    let PUSH_CER_FILE = "2020_rel_push_couponmoa"
//    let PUSH_CER_PASS = "couponmoa"
    
    let COMMON_IMAGE_URL = "https://t1.daumcdn.net/cfile/tistory/02357835516A6ACF18"
    
    var urlSession: URLSession!
    
    @IBOutlet var imageUrlField: NSTextField!
    
    @IBOutlet var cImageUrlField: NSTextField!
    @IBOutlet var cSearchField: NSTextField!
    @IBOutlet var cMainField: NSTextField!
    @IBOutlet var cProductField: NSTextField!
    @IBOutlet var cCategoryField: NSTextField!
    
    @IBOutlet var cBgSearchField: NSTextField!
    @IBOutlet var cBgMainField: NSTextField!
    @IBOutlet var cBgCategoryField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlSession = URLSession(configuration: URLSession.shared.configuration, delegate: self, delegateQueue: nil)
        
//        FileManager.default.getFileProviderServicesForItem(at: URL(fileURLWithPath: "/Users/imc056")) { (services, error) in
//            debugPrint("OK")
//        }
    }
    
    @IBAction func clickSendBtn(_ sender: AnyObject?) {
        sendPushMessage(message: "메세지 내용 길게 길게 메세지만 보냈을때는 이런식으로 수신됨.", title: "메세지만 보내기")
    }
    
    @IBAction func clickSendBtn2(_ sender: AnyObject?) {
       sendPushMessage(message: "작은 이미지가 왔을때의 수신 형태", title: "작은 이미지", urlImgString: "https://t1.daumcdn.net/cfile/tistory/21692B4E583FAF6321")
    }
    
    @IBAction func clickSendBtn3(_ sender: AnyObject?) {
        sendPushMessage(message: "보통 이미지가 왔을때의 수신 형태", title: "보통 이미지", urlImgString: "https://t1.daumcdn.net/cfile/tistory/02357835516A6ACF18")
    }
    
    @IBAction func clickSendBtn4(_ sender: AnyObject?) {
        sendPushMessage(message: "큰 이미지가 왔을때의 수신 형태", title: "큰 이미지", urlImgString: "https://tumblbug-pci.imgix.net/15f011715a817d74815ffc600fc1964fda6732fe/b9a13b763c808de23227307c2ada30b0bdf5affe/618f5f5d913696b2f47a767f4d283223b8f04e8c/28b6f5705e9b540c3680749283c6d7c20857efc1.jpg?ixlib=rb-1.1.0&w=1240&h=930&auto=format%2Ccompress&lossless=true&fit=crop&s=c078d55b90926b21788303b374ec95ef")
    }
    
    @IBAction func clickSendBtn5(_ sender: AnyObject?) {
        sendPushMessage(message: "입력한 이미지 다양한 크기를 테스트 해보기 위함.", title: "입력 이미지", urlImgString: imageUrlField.stringValue)
    }
    
    /// 푸시 메세지 전송
    ///
    /// - Parameters:
    ///     - message: 푸시 메세지
    ///     - title: 푸시 타이틀
    ///     - urlImgString: 이미지 URL 문자열
    private func sendPushMessage(message: String = "default Message", title: String? = nil, urlImgString: String? = nil) {
        
        let json = buildCompanyTestJson(message: message, title: title, urlImgString: urlImgString)
        sendPush(json)
    }
    
    private func sendPush(_ json: [String:Any]) {
        // URL Request 생성
        guard let url: URL = URL(string: "https://api.sandbox.push.apple.com:443/3/device/\(REG_ID)") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("10", forHTTPHeaderField: "apns-priority")
        urlRequest.addValue("0", forHTTPHeaderField: "apns-expiration")
        urlRequest.addValue("eabeae54-14a8-11e5-b60b-1697f925ec7b", forHTTPHeaderField: "apns-id")
        urlRequest.addValue(APP_IDENTIFIER, forHTTPHeaderField: "apns-topic")
        
        debugPrint("Before Environment")
//        debugPrint(ProcessInfo.processInfo.environment.description)
        setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
        
        debugPrint("After Environment")
//        debugPrint(ProcessInfo.processInfo.environment.description)
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            
            let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
                if let error = error {
                    debugPrint(" ===== Error LocalizedDescription ===== ")
                    debugPrint(error.localizedDescription)
                } else {
                    debugPrint(" ===== Success Send Notification ===== ")
                    debugPrint(String(data: data!, encoding: .utf8)!)
                }
            }
            
            task.resume()
        } catch {
            debugPrint("Try Exception!!")
        }
    }
    
    private func buildTestJson(message: String = "default Message", title: String? = nil, urlImgString: String? = nil) -> [String:Any] {
        var alert = [String:Any]()
        if let pushTitle = title {
            alert["title"] = pushTitle
        }
        alert["body"] = message
        //alert["subtitle"] = "" // 서브 타이틀은 일단 없음
        
        var aps = [String:Any]()
        // 푸시 기본 사운드
        aps["sound"] = "default"
        
        // Notification Service 이용시 1로 보내야함.
        aps["mutable-content"] = 1
        // Notification UI Content 이용시 해당 UI의 카테고리명 명시 해서 보냄.
        // aps["category"] = "myNotificationCategory"
        aps["alert"] = alert
        var json = [String:Any]()
        json["aps"] = aps
        
        // 이미지 전송 필드 명칭은 바뀌어도 상관없음. (클라이언트에서 받는 명칭과 맞추기만 하면됨.)
        if let imageUrl = urlImgString {
            json["urlImageString"] = imageUrl;
        }
        
        return json
    }
    
    private func buildCompanyTestJson(message: String = "default Message", title: String? = nil, urlImgString: String? = nil) -> [String:Any] {
        /// ================= ALERT ================= ///
        var alert = [String:Any]()
        if let pushTitle = title {
            alert["title"] = pushTitle
        }
        alert["body"] = message
        //alert["subtitle"] = "" // 서브 타이틀은 일단 없음
        
        /// ================= APS ================= ///
        var aps = [String:Any]()
        // 푸시 기본 사운드
        aps["sound"] = "default"
        
        // Notification Service 이용시 1로 보내야함.
        aps["mutable-content"] = 1
        // Notification UI Content 이용시 해당 UI의 카테고리명 명시 해서 보냄.
//         aps["category"] = "myNotificationCategory"
        aps["alert"] = alert
        aps["badge"] = 1
        
        /// ================= JSON ================= ///
        var json = [String:Any]()
        json["aps"] = aps
        
        // 이미지 전송 필드 명칭은 바뀌어도 상관없음. (클라이언트에서 받는 명칭과 맞추기만 하면됨.)
        if let imageUrl = urlImgString {
            json["urlImageString"] = imageUrl
        } else {
            json["urlImageString"] = COMMON_IMAGE_URL
        }
        
        json["type"] = "7"
        json["wb"] = "coochatour"
        json["mt"] = "2f9c80e9-736f-439b-8413-2e5e5d8b7e5a"
        
        return json
    }
    
    /// 상품 검색 상세 푸시
    @IBAction func touchProductSearch(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Product -> BG S", title: "P_BG_S", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "P"
        json["ldv"] = cProductField.stringValue
        
        var bgld = [String:Any]()
        bgld["ld"] = "S"
        bgld["ldv"] = cBgSearchField.stringValue
        json["bgld"] = bgld
        
        sendPush(json)
    }
    
    /// 상품 메인 상세 푸시
    @IBAction func touchProductMain(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Product -> BG M", title: "P_BG_M", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "P"
        json["ldv"] = cProductField.stringValue
        
        var bgld = [String:Any]()
        bgld["ld"] = "M"
        bgld["ldv"] = cBgMainField.stringValue
        json["bgld"] = bgld
        
        sendPush(json)
    }
    
    /// 상품 카테고리 상세 푸시
    @IBAction func touchProductCategory(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Product -> BG C", title: "P_BG_C", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "P"
        json["ldv"] = cProductField.stringValue
        
        var bgld = [String:Any]()
        bgld["ld"] = "C"
        bgld["ldv"] = cBgCategoryField.stringValue
        json["bgld"] = bgld
        
        sendPush(json)
    }
    
    /// 검색 이동
    @IBAction func touchSearch(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Search", title: "S", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "S"
        json["ldv"] = cSearchField.stringValue
        
        sendPush(json)
    }
    
    /// 카테고리 이동
    @IBAction func touchCategory(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Category", title: "C", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "C"
        json["ldv"] = cCategoryField.stringValue
        
        sendPush(json)
    }
    
    /// 메인 이동
    @IBAction func touchMain(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Main", title: "M", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "M"
        json["ldv"] = cMainField.stringValue
        
        sendPush(json)
    }
    
    /// 더보기 이동
    @IBAction func touchMore(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "More", title: "L", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "L"
        json["ldv"] = "more"
        
        sendPush(json)
    }
    
    /// 상품 상세 이동
    @IBAction func touchDetail(_ sender: AnyObject) {
        var json: [String:Any] = buildCompanyTestJson(message: "Detail", title: "H", urlImgString: cImageUrlField.stringValue)
        
        json["ld"] = "H"
        json["ldv"] = cProductField.stringValue
        
        sendPush(json)
    }

}

extension ViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        switch (challenge.protectionSpace.authenticationMethod, challenge.protectionSpace.host) {
        case (NSURLAuthenticationMethodServerTrust, "api.sandbox.push.apple.com"):
            let trust = challenge.protectionSpace.serverTrust!
            
            let credential = URLCredential(trust: trust)
            completionHandler(.useCredential, credential)
        case (NSURLAuthenticationMethodClientCertificate, "api.sandbox.push.apple.com"):
            let path = Bundle.main.path(forResource: PUSH_CER_FILE, ofType: "p12")
            debugPrint(path!)
            
            let pushUrl = URL(fileURLWithPath: path!)
            
            let pushData = try! Data(contentsOf: pushUrl)
            
            var importedCF: CFArray? = nil
            let options = [kSecImportExportPassphrase as String: PUSH_CER_PASS]
            let err = SecPKCS12Import(pushData as CFData, options as CFDictionary, &importedCF)
            precondition(err == errSecSuccess)
            let imported = importedCF! as NSArray as! [[String:AnyObject]]
            precondition(imported.count == 1)
            
            let secIdentity = (imported[0][kSecImportItemIdentity as String]!) as! SecIdentity
            completionHandler(.useCredential, URLCredential(identity: secIdentity, certificates: nil, persistence: .forSession))
        default:
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

extension Bundle {
    
    func certificate(named name: String) -> SecCertificate {
        let cerURL = self.url(forResource: name, withExtension: "cer")!
        let cerData = try! Data(contentsOf: cerURL)
        let cer = SecCertificateCreateWithData(nil, cerData as CFData)!
        return cer
    }
    
    func identity(named name: String, password: String) -> SecIdentity {
        let p12URL = self.url(forResource: name, withExtension: "p12")!
        let p12Data = try! Data(contentsOf: p12URL)
        
        var importedCF: CFArray? = nil
        let options = [kSecImportExportPassphrase as String: password]
        let err = SecPKCS12Import(p12Data as CFData, options as CFDictionary, &importedCF)
        precondition(err == errSecSuccess)
        let imported = importedCF! as NSArray as! [[String:AnyObject]]
        precondition(imported.count == 1)
        
        return (imported[0][kSecImportItemIdentity as String]!) as! SecIdentity
    }
}
