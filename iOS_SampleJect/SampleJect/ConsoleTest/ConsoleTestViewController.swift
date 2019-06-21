//
//  ConsoleViewController.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 3. 21..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class ConsoleTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

extension ConsoleTestViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            testCase1()
        case 1:
            testCase2()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConsoleTableCell", for: indexPath)
        let title: String
        
        title = "TestCase -> \(indexPath.row)"
        
        if let label = cell.textLabel {
            label.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}

struct TestAnyObjectStruct2 {
    var number: Int
    var string: String
    
    init(number: Int, string: String) {
        self.number = number
        self.string = string
    }
}

struct TestAnyObjectStruct {
    var number: Int
    var string: String
    var ttt: TestAnyObjectStruct2
    
    init(number: Int, string: String) {
        self.number = number
        self.string = string
        
        self.ttt = TestAnyObjectStruct2(number: 10, string: "test")
    }
}

class TestClass2 {
    init() {}
}

class TestClass {
    var number: Int
    var test: TestClass2!
    
    init(number: Int) {
        self.number = number
        
    }
    
    func print() {
        debugPrint("잘됨")
    }
}


// MARK: - iOS Console Test Funcs
extension ConsoleTestViewController {
    func testCase1() {
        let string: NSString = "모바일 핫딜쇼핑 포털 쿠폰모아"
        
        //encodeString.addingPercentEncoding(withAllowedCharacters: )
        let encodeString = string.addingPercentEscapes(using: 4)

        print(encodeString)
        
        let encodeString2 = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(encodeString2)
        
        print(NSCharacterSet.urlQueryAllowed)
        
        print("test case 1")
        
    }
    
    func testCase2() {
        let functionTest = testfunction()
        debugPrint(functionTest(10))
        
        var testClass: TestClass? = TestClass(number: 10)
        var testClass2 = testClass
        test(test: nil)
        testClass = TestClass(number: 10)
        debugPrint(testClass2)
    }
    
    func test(test: TestClass!) {
        test.print()
        debugPrint(test?.test)
        
    }
    
    func testfunction() -> (Int) -> Int {
        func inFunction(a: Int) -> Int {
            return a
        }
        
        return inFunction
    }
    
}
