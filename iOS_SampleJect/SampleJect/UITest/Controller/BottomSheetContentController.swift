//
//  BottomSheetContentController.swift
//  SampleJect
//
//  Created by ben on 2022/03/14.
//  Copyright © 2022 SinKyoUk. All rights reserved.
//

import UIKit
import MaterialComponents

class BottomSheetContentController: UIViewController {
    // MARK: - Variable
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Class Func
    class func open(from: UIViewController) {
        let contentController = BottomSheetContentController(nibName: "BottomSheetContentController", bundle: Bundle.main)
        let bottomSheet = MDCBottomSheetController(contentViewController: contentController)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 2200
        bottomSheet.mdc_bottomSheetPresentationController?.scrimColor = UIColor.clear
        from.present(bottomSheet, animated: true, completion: nil)
    }

    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
