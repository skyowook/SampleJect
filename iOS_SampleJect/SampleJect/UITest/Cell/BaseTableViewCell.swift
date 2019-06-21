//
//  BaseTableViewCell.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 3. 20..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var contentSubView: BaseContentView?
    
    /// 셀에 컨텐츠 뷰 등록
    ///
    /// - Parameter view: 커스텀 컨텐츠 뷰
    public func setContentSubView(contentSubView view:BaseContentView!) {
        contentSubView?.removeFromSuperview()
        
        contentSubView = view
        addSubview(contentSubView!)
        
        applyConstraint(contentSubView: contentSubView!)
    }
    
    /// 컨텐츠 뷰 AutoLayout 적용
    ///
    /// - Parameter view: 컨텐츠 뷰
    private func applyConstraint(contentSubView view:UIView!) {
        view!.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: view!,
                                                                   attribute: .top,
                                                                   relatedBy: .equal,
                                                                   toItem: self,
                                                                   attribute: .top,
                                                                   multiplier: 1.0,
                                                                   constant: 0.0)
        
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: view!,
                                                                      attribute: .bottom,
                                                                      relatedBy: .equal,
                                                                      toItem: self,
                                                                      attribute: .bottom,
                                                                      multiplier: 1.0,
                                                                      constant: 0.0)
        
        let leadingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: view!,
                                                                       attribute: .leading,
                                                                       relatedBy: .equal,
                                                                       toItem: self,
                                                                       attribute: .leading,
                                                                       multiplier: 1.0,
                                                                       constant: 0.0)
        
        let trailingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: view!,
                                                                        attribute: .trailing,
                                                                        relatedBy: .equal,
                                                                        toItem: self,
                                                                        attribute: .trailing,
                                                                        multiplier: 1.0,
                                                                        constant: 0.0)
        
        self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}
