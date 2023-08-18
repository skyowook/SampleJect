//
//  SwiftUISampleApp.swift
//  SwiftUISample
//
//  Created by skw on 8/17/23.
//

import SwiftUI

@main
struct SwiftUISampleApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: didBecomeActiveNotification(_:))
        }
    }
    
    func didBecomeActiveNotification(_ center: NotificationCenter.Publisher.Output) {
        
    }
    
    func contentViewLifeCycle() {
        
    }
}
