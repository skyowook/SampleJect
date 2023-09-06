//
//  TossReq.swift
//  TossSampleIos
//
//  Created by skw on 8/24/23.
//

import Foundation

/// 토스 본인인증 표준창 정보 요청 필드
struct TossSignAuthReq: Codable {
    var requestType: String = ""
}

struct TossSignAuthResultReq: Codable {
    var txId: String = ""
    var sessionKey: String = ""
}
