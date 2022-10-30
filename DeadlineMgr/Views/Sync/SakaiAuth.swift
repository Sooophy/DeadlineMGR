//
//  SakaiAuth.swift
//  deadline_manager
//
//  Created by Tianjun Mo on 2022/10/17.
//

import SwiftUI
import WebKit

struct SakaiAuth: View {
    @StateObject var webViewStore = WebViewStore(
        navigationDelegate: SakaiWKNavigationDelegate()
    )
    @StateObject var sakaiStore: SakaiStore
    @Binding var isModalShow: Bool

    init(isModalShow: Binding<Bool>) {
        self._sakaiStore = StateObject(wrappedValue: SakaiStore.shared)
        self._isModalShow = isModalShow
    }

    var cookiesStr: String {
        sakaiStore.cookies.map { key, value in "\(key):\(value)" }.reduce("") { partialResult, s in
            partialResult + "; " + s
        }
    }

    var body: some View {
        VStack {
            WebView(webView: webViewStore.webView).onAppear {
                self.webViewStore.webView.load(URLRequest(url: URL(string: "https://sakai.duke.edu/")!))
            }
        }.onChange(of: sakaiStore.cookies) { _ in
            isModalShow = false
        }
    }
}

struct SakaiAuth_Previews: PreviewProvider {
    static var previews: some View {
        SakaiAuth(isModalShow: Binding(get: {
            true
        }, set: { _, _ in

        }))
    }
}

public class SakaiWKNavigationDelegate: NSObject, WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.url!.absoluteString.starts(with: "https://sakai.duke.edu/portal/site") {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    if cookie.domain == "sakai.duke.edu" {
                        SakaiStore.shared.cookies[cookie.name] = cookie.value
                    }
                }
                SakaiStore.shared.saveCookies()
                SakaiStore.shared.fetchInfo()
            }
        }
        print(webView.url!.absoluteString, "finish")
    }
}
