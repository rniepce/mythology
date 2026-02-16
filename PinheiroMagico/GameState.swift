import Foundation
import WebKit
import Combine

/// ObservableObject que recebe o estado do jogo via JS bridge
class GameState: NSObject, ObservableObject {

    // MARK: - Published State
    @Published var dracmas: Int = 0
    @Published var vidas: Int = 3
    @Published var nivel: Int = 1
    @Published var isGameOver: Bool = false
    @Published var monstrosDestruidos: Int = 0
    @Published var bossesDestruidos: Int = 0
    @Published var tempoDeJogo: Double = 0
    @Published var bossWarning: Bool = false
    @Published var highScore: Int = 0

    // Referência fraca ao webView para enviar comandos
    weak var webView: WKWebView?

    // MARK: - Actions

    func restart() {
        webView?.evaluateJavaScript("reiniciarJogo()") { _, error in
            if let error = error {
                print("❌ Erro ao reiniciar: \(error)")
            }
        }
        DispatchQueue.main.async {
            self.isGameOver = false
        }
    }
}

// MARK: - WKScriptMessageHandler
extension GameState: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard message.name == "gameState",
              let body = message.body as? [String: Any] else { return }

        DispatchQueue.main.async {
            if let d = body["dracmas"] as? Int { self.dracmas = d }
            if let v = body["vidas"] as? Int { self.vidas = v }
            if let n = body["nivel"] as? Int { self.nivel = n }
            if let m = body["monstrosDestruidos"] as? Int { self.monstrosDestruidos = m }
            if let b = body["bossesDestruidos"] as? Int { self.bossesDestruidos = b }
            if let t = body["tempoDeJogo"] as? Double { self.tempoDeJogo = t }
            if let h = body["highScore"] as? Int { self.highScore = h }

            if let go = body["gameOver"] as? Bool { self.isGameOver = go }
            if let bw = body["bossWarning"] as? Bool { self.bossWarning = bw }
        }
    }
}
