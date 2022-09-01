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
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
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
                                            attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle : paragraphStyle],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// 해당 문자열의 가로 길이 구하기
    ///
    /// - Parameter font: 폰트
    func width(font: UIFont) -> CGFloat {
        let width: CGFloat = .greatestFiniteMagnitude
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
    
    /// 한문장의 문자열이 특정 폰트를 가지고 어떤 가로크기의 Label에 들어갔을 때 다음 줄로 넘어가는 Offset 검색
    ///
    /// - Parameters:
    ///     - width: 텍스트가 들어갈 UI의 가로 폭
    ///     - attributes: 텍스트가 들어갈 UI의 속성 (폰트 등 크기에 영향을 줄 수 있는 속성)
    /// - Returns: 검색된 Offset
    func getNextLineOffsetForWidth(_ width: CGFloat, attributes: [NSAttributedString.Key : Any]? = nil) -> Int {
        let rect = self.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let oneLineHeight = "가".boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height
        
        if rect.height == oneLineHeight {
            return 0
        }
        
        var searchOffset: Int = self.count / 2
        var checkLength: CGFloat = CGFloat(searchOffset)
        var loopCount = 0
        
        while(true) {
            loopCount += 1
            
            let subString = self.prefix(searchOffset).description
            let nextSubString = self.prefix(searchOffset + 1).description
            
            let subStringRect = subString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let nextSubStringRect = nextSubString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            checkLength = (checkLength / 2.0 + 0.5)
            
            if subStringRect.height == oneLineHeight && nextSubStringRect.height > oneLineHeight {
                return searchOffset
            } else if subStringRect.height == oneLineHeight && nextSubStringRect.height == oneLineHeight {
                searchOffset += Int(checkLength)
            } else if subStringRect.height > oneLineHeight && nextSubStringRect.height > oneLineHeight {
                searchOffset -= Int(checkLength)
            }
            
            if checkLength == 0 {
                return 0
            }
        }
    }
    
    /// 긴 문장에서의 개행 Offset지점을 배열로 반환 단. \n문자열이 들어오면 공백으로 치환해서 가로폭 내에 들어갈 오프셋들을 배열로 반환한다.
    /// \n문자를 포함한 결과를 얻고 싶다면 componentsForLineWidth를 호출하면 한줄 한줄에 들어갈 문자열 배열을 얻을 수 있다.
    ///
    /// - Parameters:
    ///     - width: 텍스트가 들어갈 UI의 가로 폭
    ///     - attributes: 텍스트가 들어갈 UI의 속성 (폰트 등 크기에 영향을 줄 수 있는 속성)
    /// - Returns: 검색된 Offset 배열
    func getLineOffsetsForWidth(_ width: CGFloat, attributes: [NSAttributedString.Key : Any]? = nil) -> [Int] {
        var checkString = self.replacingOccurrences(of: "\n", with: "")
        var lineOffsets: [Int] = [Int]()
        var offset: Int = 0
        
        while(true) {
            let nextLineOffset = checkString.getNextLineOffsetForWidth(width, attributes: attributes)
            if nextLineOffset == 0 {
                break
            }
            
            offset += nextLineOffset
            lineOffsets.append(nextLineOffset)
            checkString = checkString.suffix(checkString.count - nextLineOffset).description
        }
        
        return lineOffsets
    }
    
    /// 입력된 가로폭에 맞게 긴문장이 들어갔을 때 한줄 한줄에 나올 문자열들을 배열에 묶어 반환해준다.
    ///
    /// - Parameters:
    ///     - width: 텍스트가 들어갈 UI의 가로 폭
    ///     - attributes: 텍스트가 들어갈 UI의 속성 (폰트 등 크기에 영향을 줄 수 있는 속성)
    /// - Returns: 한줄 한줄에 들어갈 문자열 배열
    func componentsForLineWidth(_ width: CGFloat, attributes: [NSAttributedString.Key : Any]? = nil) -> [String] {
        var lineComponents: [String] = [String]()
        let components = self.components(separatedBy: "\n")
        
        for component in components {
            let arrayOffset = component.getLineOffsetsForWidth(width, attributes: attributes)
            var printString = component
            
            for offset in arrayOffset {
                lineComponents.append(printString.prefix(offset).description)
                printString = printString.suffix(printString.count - offset).description
            }
            
            lineComponents.append(printString)
        }
        
        return lineComponents
    }
    
    /// 텍스트에 특정 단어 강조 표시 넣기
    ///
    /// - Parameters:
    ///     - baseAttribute: 초기 문자열의 속성
    ///     - highlightWord: 강조 단어
    ///     - highlightAttribute: 강조 단어의 속성
    private func getHighlightAttributedString(baseAttribute: [NSAttributedString.Key : Any], highlightWord: String, highlightAttribute: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let baseAttributed = NSMutableAttributedString(string: self, attributes: baseAttribute)
        let range = NSRange(location: 0, length: self.count)
        guard let regex = try? NSRegularExpression(pattern: highlightWord, options: .caseInsensitive) else {
            return baseAttributed
        }

        regex.matches(in: self, options: .withTransparentBounds, range: range).forEach {
            baseAttributed.addAttributes(highlightAttribute, range: $0.range)
        }
        
        return baseAttributed
    }
}
