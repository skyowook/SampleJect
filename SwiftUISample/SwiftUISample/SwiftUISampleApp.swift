//
//  SwiftUISampleApp.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI

@main
struct SwiftUISampleApp: App {
    // 비활성으로 갈때 inactive > background
    // 활성으로 갈 때 inactive > active
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            MainView()
        }.onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                debugPrint("new ::: active")
            case .inactive:
                debugPrint("new ::: inactive")
            case .background:
                debugPrint("new ::: background")
            default:
                debugPrint("old ::: ??? ")
            }
        }
    }
    
    func didBecomeActiveNotification(_ center: NotificationCenter.Publisher.Output) {
    
    }
    
    func contentViewLifeCycle() {
        
    }
}
