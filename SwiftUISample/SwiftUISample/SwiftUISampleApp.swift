//
//  SwiftUISampleApp.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI
import IAssistKit

@main
struct SwiftUISampleApp: App {
    // 비활성으로 갈때 inactive > background
    // 활성으로 갈 때 inactive > active
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
//            MainView()
            TutorialView()
        }.onChange(of: scenePhase, { oldPhase, newPhase in
            debugPrint("old Phase ::: \(oldPhase)")
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
        })
    }
    
    func didBecomeActiveNotification(_ center: NotificationCenter.Publisher.Output) {
    
    }
    
    func contentViewLifeCycle() {
        
    }
}
