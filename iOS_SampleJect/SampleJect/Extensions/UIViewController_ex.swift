//
//  UIViewController_ex.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 10. 26..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import Foundation

extension UIViewController {
    /// 네비게이션 바 뒤로가기 타이틀 변경
    /// - Parameter title: 타이틀
    func setNavigationBackTitle(_ title: String) {
        if let backBar = self.navigationController?.navigationBar.topItem {
            backBar.title = title
        }
    }
}
