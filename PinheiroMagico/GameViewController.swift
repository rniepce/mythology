import UIKit
import WebKit

class GameViewController: UIViewController {

    private var webView: WKWebView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupWebView()
        loadGame()
    }

    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .all }

    // MARK: - WebView Setup

    private func setupWebView() {
        let config = WKWebViewConfiguration()

        // Permitir áudio inline (Web Audio API)
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Preferências
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black

        // Desabilitar scroll e zoom (o jogo cuida disso via canvas)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false
        webView.scrollView.maximumZoomScale = 1.0
        webView.scrollView.minimumZoomScale = 1.0

        // Impedir seleção de texto e menus de contexto
        webView.allowsLinkPreview = false

        view.addSubview(webView)

        // Tela cheia — cobrir toda a área incluindo safe area
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Load Game

    private func loadGame() {
        // Procurar jogo.html dentro do bundle na pasta GameWeb
        guard let gameURL = Bundle.main.url(forResource: "jogo",
                                             withExtension: "html",
                                             subdirectory: "GameWeb") else {
            print("❌ jogo.html não encontrado no bundle!")
            showError()
            return
        }

        // Diretório base para que as imagens (arvore.png etc.) sejam encontradas
        let baseDir = gameURL.deletingLastPathComponent()
        webView.loadFileURL(gameURL, allowingReadAccessTo: baseDir)
        print("🎮 Carregando jogo de: \(gameURL.path)")
    }

    private func showError() {
        let label = UILabel()
        label.text = "❌ Erro ao carregar o jogo"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
