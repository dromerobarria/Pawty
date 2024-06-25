//
//  ContentView.swift
//  ConciertosChile
//
//  Created by Daniel Romero on 21-01-24.
//

import SwiftUI
import WebKit

struct NewsView: View {
    var body: some View {
        WebView()
    }
    
    struct WebView: UIViewRepresentable {
     
        let webView: WKWebView
        
        init() {
            webView = WKWebView(frame: .zero)
          
        }
        
        func makeUIView(context: Context) -> WKWebView {
            return webView
        }
        func updateUIView(_ uiView: WKWebView, context: Context) {
            webView.load(URLRequest(url: URL(string: "https://www.nationalgeographic.es/animales")!))
        }
    }
}
