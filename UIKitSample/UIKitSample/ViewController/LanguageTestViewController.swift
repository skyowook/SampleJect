//
//  LanguageTestViewController.swift
//  UIKitSample
//
//  Created by skw on 7/26/24.
//

import UIKit

extension Array {
    // read - write
  subscript(test index: Index) -> Element? {
      get {
        return self[index]
      }
      set(newValue) {
          if let value = newValue {
              self.insert(value, at: index)
          }
      }
  }

    // read only
    subscript(test2 index: Index) -> Element? {
        return self[index]
    }
}

enum TestEnum {
    case a, b, c, d
    case f
}

enum TestIntEnum: Int {
    case a, b, c, d
    case f = 10
}

enum TestDoubleEnum: Double {
    case a, b, c, d
    case f = 20.0
}

enum TestStringEnum: String {
    case a, b, c, d
    case e = "f"
    case f = "test"
}

enum TestParamEnum {
    case a(index: Int)
    case b(Int, Int)
}

/// 스위프트 문법 테스트 화면
class LanguageTestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageTest_enum()
    }
    
    func languageTest_tuple() {
        let tuple = (1, (2, 3), 3)
        debugPrint(tuple.1.1)
    }
    
    func languageTest_arrayCapacity() {
        var array: [Int] = []
        debugPrint(array.capacity)
        debugPrint(array.count)
        debugPrint("==============")
        array.append(0)
        for _ in 0..<33 {
            array.append(0)
        }
        debugPrint(array.capacity)
        debugPrint(array.count)
        debugPrint("==============")
        array.reserveCapacity(100)
        debugPrint(array.capacity)
        debugPrint(array.count)
        
        array[test: 30] = 20
        debugPrint("==============")
        debugPrint(array[test2: 30] ?? 0)
    }
    
    func languageTest_enum() {
        var value: TestEnum = .a
        debugPrint(value)
        value = .b
        debugPrint(value)
        value = .f
        debugPrint(value)
        debugPrint("================")
        
        var value1: TestIntEnum = .a
        debugPrint(value1.rawValue)
        value1 = .b
        debugPrint(value1.rawValue)
        value1 = .f
        debugPrint(value1.rawValue)
        debugPrint("================")
        
        var value2: TestStringEnum = .a
        debugPrint(value2.rawValue)
        value2 = .b
        debugPrint(value2.rawValue)
        value2 = .f
        debugPrint(value2.rawValue)
        debugPrint("================")
        
        var value3: TestDoubleEnum = .a
        debugPrint(value3.rawValue)
        value3 = .b
        debugPrint(value3.rawValue)
        value3 = .f
        debugPrint(value3.rawValue)
        debugPrint("================")
        
        let value4: TestParamEnum = .a(index: 20)
        debugPrint(value4)
    }
    
    func test() {
        let label = "The width is "
        let width = 94
        let widthLabel = label + String(width)
    }
}
