//
//  RunLoopViewController.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 10. 29..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class RunLoopViewController: UIViewController {
    var testFlag: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Func
    @IBAction func touchOneButton(_ sender: AnyObject) {
        runLoopTest()
    }
    
    @IBAction func touchSevenButton(_ sender: AnyObject) {
        testFlag = true
    }
    
    // MARK: - Private Func
    private func runLoopTest() {
        DispatchQueue.global().async {
            while !self.testFlag {
                debugPrint("infinite")
                //            RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
            }
        }
    }
    
}
