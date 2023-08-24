//
//  TossWebViewBridge.swift
//  TossSampleIos
//
//  Created by skw on 8/24/23.
//

import SwiftUI
import WebKit

struct TossWebViewWrapper: UIViewRepresentable {
    private var webview = TossWebView(frame: .zero, configuration: WKWebViewConfiguration())
    func makeUIView(context: Context) -> some UIView {
        return webview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func tossLoad() {
        webview.load()
    }
}
