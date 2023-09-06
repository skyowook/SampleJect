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

/// 토스 본인인증 결과 유저 데이터 (암호화 된 값)
/// - 요청 할 때 사용 했던 세션키(토스sdk)객체 활용해서 복호화 가능
struct TossPersonalData: Decodable {
    var ci: String?
    var name: String?
    var birthday: String?
    var gender: String?
    var nationality: String?
    var ci2: String?
    var di: String?
    var ciUpdate: String?
}


struct TossSignAuthResult: Decodable {
    var txId: String?
    var status: String?
    var userIdentifier: String?
    var userCiToken: String?
    var signature: String?
    var randomValue: String?
    var completedDt: String?
    var requestedDt: String?
    var personalData: TossPersonalData?
}
