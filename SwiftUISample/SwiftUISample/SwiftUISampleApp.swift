//
//  SwiftUISampleApp.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI

protocol TestProtocol {
    
}

struct TestStruct : TestProtocol {
    
}

struct Test2Struct : TestProtocol {
    
}

@main
struct SwiftUISampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    func didBecomeActiveNotification(_ center: NotificationCenter.Publisher.Output) {
    
    }
    
    func contentViewLifeCycle() {
        
    }
}
