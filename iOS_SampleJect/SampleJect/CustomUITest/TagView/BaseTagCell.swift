//
//  BaseTagCollectionCell.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 4. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

protocol TagCellDelegate : NSObjectProtocol {
    /// 태그 삭제
    ///
    /// - Parameter tagCell: 태그 셀
    func deleteTagCell(_ tagCell: BaseTagCell)
    
    /// 태그 선택
    ///
    /// - Parameter tagCell: 태그 셀
    func selectTagCell(_ tagCell: BaseTagCell)
    
    /// 태그 선택 해제
    ///
    /// - Parameter tagCell: 태그 셀
    func deselectTagCell(_ tagCell: BaseTagCell)
    
    /// 태그 터치
    ///
    /// - Parameter tagCell: 태그 셀
    func touchTag(_ tagCell: BaseTagCell)
}

class BaseTagCell: UICollectionViewCell {
    /// 액션 타입
    enum ActionType {
        case select
        case view
    }
    
    @IBOutlet private weak var textLabel: UILabel!      // 텍스트 레이블
    
    var delegate: TagCellDelegate?              // 델리게이트
    var actionType: ActionType = .view          // 액션 타입
    
    var isTagSelected: Bool = false             // 태그 선택 여부
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let touchGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseTagCell.gestureHandle(_:)))
        addGestureRecognizer(touchGesture)
    }
    
    /// 태그 초기화
    func initTag() {
        actionType = .view
    }
    
    /// 뷰 사이즈에서 태그 문자열 길이를 더한 태그 사이즈 반환
    ///
    /// - Parameter tagString: 태그값
    /// - Returns: 태그 텍스트까지 포함된 태그 사이즈 반환
    func getTagSize(withTagString tagString: String?) -> CGSize {
        var size = getDefaultSize()
        
        if let tag = tagString {
            size.width += tag.width(font: textLabel.font)
            
            return size
        }
        
        return size
    }
    
    @objc func gestureHandle(_ sender: UITapGestureRecognizer) {
        switch actionType {
        case .view:
            if let del = delegate {
                del.touchTag(self)
            }
        case .select:
            isTagSelected = !isTagSelected
            isTagSelected ? selectedUI() : deselectedUI()
            
            if let del = delegate {
                isTagSelected ? del.selectTagCell(self) : del.deselectTagCell(self)
            }
        }
    }
    
    /// 서브 클래스 태그영역을 제외한 영역(마진, 기타뷰사이즈) 사이즈 반환
    ///
    /// - Returns: 사이즈
    func getDefaultSize() -> CGSize {
        // SubClass Work
        return CGSize.zero
    }
    
    /// 태그 삭제
    func deleteTag() {
        if let del = delegate {
            del.deleteTagCell(self)
        }
    }
    
    /// 태그 텍스트 등록 서브클래스에서 오버라이딩 해서 텍스트에 대한 연출 작업을 할수 있도록 셋터 별도로 작업
    ///
    /// - Parameter text: 텍스트
    func setTagText(_ text: String?) {
        textLabel.text = text
    }
    
    /// 태그 텍스트 반환
    ///
    /// - Returns: 태그 텍스트
    func getTagText() -> String? {
        return textLabel.text
    }
    
    // MARK: - SubClass에서 구현
    /// 선택된 UI 처리
    func selectedUI() {}
    /// 선택 해제된 UI 처리
    func deselectedUI() {}
    
    // mode : select, click, view
    
    // select 기능
    // delete 기능
    // click 기능
}
