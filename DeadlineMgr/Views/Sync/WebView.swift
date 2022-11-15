import Combine
import SwiftUI
import WebKit

@dynamicMemberLookup
public class WebViewStore: ObservableObject {
    @Published public var webView: WKWebView {
        didSet {
            setupObservers()
        }
    }
  
    public init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        setupObservers()
    }
  
    private func setupObservers() {
        func subscriber<Value>(for keyPath: KeyPath<WKWebView, Value>) -> NSKeyValueObservation {
            return webView.observe(keyPath, options: [.prior]) { _, change in
                if change.isPrior {
                    self.objectWillChange.send()
                }
            }
        }
        // Setup observers for all KVO compliant properties
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward)
        ]
        if #available(iOS 15.0, macOS 12.0, *) {
            observers += [
                subscriber(for: \.themeColor),
                subscriber(for: \.underPageBackgroundColor),
                subscriber(for: \.microphoneCaptureState),
                subscriber(for: \.cameraCaptureState)
            ]
        }
#if swift(>=5.7)
        if #available(iOS 16.0, macOS 13.0, *) {
            observers.append(subscriber(for: \.fullscreenState))
        }
#else
        if #available(iOS 15.0, macOS 12.0, *) {
            observers.append(subscriber(for: \.fullscreenState))
        }
#endif
    }
  
    private var observers: [NSKeyValueObservation] = []
  
    public subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }
}

public struct WebView: View, UIViewRepresentable {
    /// The WKWebView to display
    public let webView: WKWebView
    
    public init(webView: WKWebView) {
        self.webView = webView
    }
  
    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.configuration.websiteDataStore = WKWebsiteDataStore.default()
        print("isPersistent", webView.configuration.websiteDataStore.isPersistent)
        return webView
    }
  
    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}
    
    public class Coordinator: SakaiWKNavigationDelegate {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
