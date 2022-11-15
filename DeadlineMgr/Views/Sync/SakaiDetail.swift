//
//  SakaiDetail.swift
//  DeadlineMgr
//
//  Created by Tianjun Mo on 2022/11/15.
//

import SwiftUI
import WebKit

struct SakaiDetail: View {
    @StateObject var webViewStore = WebViewStore()
    @StateObject var sakaiStore: SakaiStore
    var url: String

    init(_ url: String) {
        self.url = url
        self._sakaiStore = StateObject(wrappedValue: SakaiStore.shared)
    }

    var body: some View {
        VStack {
            WebView(webView: webViewStore.webView).onAppear {
                self.webViewStore.webView.load(URLRequest(url: URL(string: self.url)!))
            }
        }
    }
}

struct SakaiDetail_Previews: PreviewProvider {
    static var previews: some View {
        SakaiDetail("https://sakai.duke.edu/direct/assignment/ca26cc75-60ae-481c-9d2d-c2a9091b1939")
    }
}
