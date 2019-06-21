//
//  StackViewTestController.swift
//  SampleJect
//
//  Created by Sin's Retina on 2018. 8. 3..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

/// xib에서 ScrollView안에 StackView가 있을 때
/// StackView안의 이미지뷰가 별도의 autolayout이 없이 스크롤링이 되도록 하는 샘플
class StackViewTestController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Stack View"
        setNavigationBackTitle("뒤로")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
