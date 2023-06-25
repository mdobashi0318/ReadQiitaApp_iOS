//
//  WebView.swift
//  ReadQiitaApp_iOS
//
//  Created by 土橋正晴 on 2023/05/28.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let loardUrl: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: loardUrl)
        webView.load(request)
    }
}


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(loardUrl: URL(string:"")!)
    }
}
