import SwiftUI
import WebKit

/// UIViewRepresentable que envolve o WKWebView do jogo
struct GameWebView: UIViewRepresentable {

    @ObservedObject var gameState: GameState

    func makeUIView(context: Context) -> WKWebView {

        let config = WKWebViewConfiguration()

        // Permitir áudio inline
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // JS habilitado
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        // Registrar o handler da ponte JS → Swift
        config.userContentController.add(gameState, name: "gameState")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false
        webView.scrollView.maximumZoomScale = 1.0
        webView.scrollView.minimumZoomScale = 1.0
        webView.allowsLinkPreview = false

        // Guardar referência para o GameState poder chamar JS
        gameState.webView = webView

        // Carregar jogo.html
        if let gameURL = Bundle.main.url(forResource: "jogo",
                                          withExtension: "html",
                                          subdirectory: "GameWeb") {
            let baseDir = gameURL.deletingLastPathComponent()
            webView.loadFileURL(gameURL, allowingReadAccessTo: baseDir)
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nada a atualizar reativamente — o JS é o dono do loop
    }
}
