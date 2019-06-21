//
//  RN_Util_String.swift
//  Coupon_Chart_5
//
//  Created by IMC056 on 2018. 4. 11..
//  Copyright © 2018년 iMac. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 해당 문자열의 가로가 지정되어 있을때 길이에 따른 높이 구하기
    ///
    /// - Parameters:
    ///     - width: 가로 길이
    ///     - font: 폰트
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// 해당 문자열의 가로가 지정되어 있을때 길이에 따른 높이 구하기
    ///
    /// - Parameters:
    ///     - width: 가로 길이
    ///     - font: 폰트
    ///     - paragraphStyle: ??
    func height(withConstrainedWidth width: CGFloat, font: UIFont, paragraphStyle: NSParagraphStyle) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle : paragraphStyle],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// 해당 문자열의 가로 길이 구하기
    ///
    /// - Parameter font: 폰트
    func width(font: UIFont) -> CGFloat {
        let width: CGFloat = .greatestFiniteMagnitude
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
