//
//  FontEx.swift
//  SwiftUISample
//
//  Created by skw on 8/21/23.
//

import SwiftUI

/// 애플 산돌 고딕 구조체
struct AppleSDGothic {
    static let fontName = "AppleSDGothicNeo"
    
    enum Weight: String {
        case thin = "Thin"
        case ultraLight = "UltraLight"
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case semiBold = "SemiBold"
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case heavy = "Heavy"
    }
    
    var size: CGFloat = 10
    var weight: Weight = .regular
    var isFixed = true
    
    private var name: String {
        return "\(AppleSDGothic.fontName)-\(weight.rawValue)"
    }
    
    func toFont() -> Font {
        return isFixed ? Font.custom(name, fixedSize: size) : Font.custom(name, size: size)
    }
}

extension Font {
    static func appleSDGothic(_ size: CGFloat, _ weight: AppleSDGothic.Weight, _ isFixed: Bool = true) -> Font {
        return AppleSDGothic(size: size, weight: weight, isFixed: isFixed).toFont()
    }
}
