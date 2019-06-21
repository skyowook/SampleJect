//
//  RefreshContentView.swift
//  TestProject
//
//  Created by IMC056 on 2018. 3. 20..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class RefreshContentView: BaseContentView {
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Class Funcs
    /// 딜 List 형태 뷰 생성
    ///
    /// - Returns: 딜 List 형태 뷰
    class func createView() -> RefreshContentView {
        let nib01 = UINib(nibName: "RefreshContentView", bundle: nil)
        let nib02 = UINib(nibName: "RefreshContentView", bundle: nil)
        
        if nib01 == nib02 {
            debugPrint("UINIB이 같다")
        }
        
        let view01 = nib01.instantiate(withOwner: nil, options: nil)[0] as! RefreshContentView
        let view02 = nib01.instantiate(withOwner: nil, options: nil)[0] as! RefreshContentView
        
        if view01 == view02 {
            debugPrint("뷰가 같다")
        }

        return UINib(nibName: "RefreshContentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RefreshContentView
    }
    
    /// 컨텐츠 뷰가 들어갈 셀의 크기 반환
    ///
    /// - Parameter width: 컨테이너(Table, Collection)뷰 width
    /// - Returns: 사이즈
    class func sizeForCell(containerWidth width: CGFloat) -> CGSize {
        // FIXME: 현재 임시 사이즈 디자인 대응 필요
        return CGSize(width: width, height: 190.0)
    }
    // MARK: -

    
    /// 새로고침 버튼 클릭
    ///
    /// - Parameter sender: 버튼
    @IBAction func clickRefreshBtn(_ sender: AnyObject) {
        debugPrint("갱신 클릭!!")
        refreshContentView()
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
