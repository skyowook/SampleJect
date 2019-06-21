//
//  BaseContentView.swift
//  TestProject
//
//  Created by IMC056 on 2018. 3. 20..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

protocol BaseContentViewDelegate: NSObjectProtocol {
    func refreshContentView()
}

class BaseContentView: UIView {
    /// 컨텐츠 뷰 타입 :: /Common/ContentViewType.swift에서 참조
    public var contentViewType: ContentViewType!
    
    /// 기본 뷰 델리게이션
    public weak var delegate: BaseContentViewDelegate?
    
    /// Cell Row Index
    public var rowIndex: Int = -1
    /// Cell Section Index
    public var sectionIndex: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    /// 뷰 데이터 셋업
    ///
    /// - Parameter data: 데이터 모델
    public func setupView(withData data: AnyObject?, sectionIdx section:Int, rowIdx row: Int) {
        sectionIndex = section
        rowIndex = row
        
    }
    
    /// 컨텐츠 뷰 타입 반환
    ///
    /// - Returns: 컨텐츠 타입
    public func getContentViewType() -> ContentViewType! {
        return contentViewType
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension BaseContentView: BaseContentViewDelegate {
    func refreshContentView() {
        
        if let del = delegate {
            del.refreshContentView()
        }
    }
}
