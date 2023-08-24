//
//  TossRes.swift
//  TossSampleIos
//
//  Created by skw on 8/24/23.
//

import Foundation

/// 토스 AccessToken
struct TossTokenRes: Decodable {
    var token: String?
    var scope: String?
    var tokenType: String?
    var expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case scope
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

/// 토스 API 통신 결과 기본 형태
struct TossApiRes<RESULT>: Decodable where RESULT: Decodable {
    var resultType: String?
    var success: RESULT?
    var error: TossApiError?
}

/// 토스 API 에러
struct TossApiError: Decodable {
    var errorType: Int?
    var errorCode: String?
    var reason: String?
}

/// 토스 본인인증 표준창 정보
struct TossSignAuthInfo: Decodable {
    var txId: String?
    var appScheme: String?
    var androidAppUri: String?
    var iosAppUri: String?
    var requestedDt: String?
    var authUrl: String?
}
