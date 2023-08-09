//
//  LoginModel.swift
//  LoginTest
//
//  Created by ben on 2020/04/10.
//  Copyright © 2020 Ben. All rights reserved.
//

import Foundation

class RN_AppleLoginModel : Codable {
    var identifier: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "sub"
        case email
    }
}
