import SwiftUI

// MARK: - Main Content View

struct ContentView: View {
    @StateObject private var gameState = GameState()

    var body: some View {
        ZStack {
            // Game Canvas (full screen, behind everything)
            GameWebView(gameState: gameState)
                .ignoresSafeArea()

            // --- Native HUD Overlay ---
            VStack {
                hudBar
                Spacer()
            }
            .padding(.top, 8)

            // --- Boss Warning ---
            if gameState.bossWarning {
                bossWarningBanner
                    .transition(.scale.combined(with: .opacity))
            }

            // --- Game Over ---
            if gameState.isGameOver {
                gameOverOverlay
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: gameState.isGameOver)
        .animation(.easeInOut(duration: 0.3), value: gameState.bossWarning)
        .preferredColorScheme(.dark)
        .persistentSystemOverlays(.hidden)
        .statusBarHidden()
    }

    // MARK: - HUD Bar

    private var hudBar: some View {
        HStack(spacing: 10) {
            // Score
            HStack(spacing: 4) {
                Text("💰")
                Text("\(gameState.dracmas)")
                    .fontWeight(.semibold)
                    .contentTransition(.numericText())
            }
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(.yellow)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .glassEffect(.regular.interactive(), in: .capsule)

            // Level
            Text("NÍVEL \(gameState.nivel)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(.orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .glassEffect(.regular, in: .capsule)

            Spacer()

            // Lives
            Text(livesText)
                .font(.system(size: 15))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .glassEffect(.regular.interactive(), in: .capsule)
        }
        .padding(.horizontal, 16)
    }

    private var livesText: String {
        var text = ""
        for i in 0..<3 {
            text += (i < gameState.vidas) ? "❤️" : "🖤"
        }
        return text
    }

    // MARK: - Boss Warning Banner

    private var bossWarningBanner: some View {
        VStack(spacing: 4) {
            Text("⚠️ BOSS ⚠️")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
            Text("MINOTAURO SE APROXIMA")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
        .glassEffect(.regular.tint(.red), in: .rect(cornerRadius: 20))
    }

    // MARK: - Game Over Overlay

    private var gameOverOverlay: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            // Glass card
            VStack(spacing: 16) {

                Text("GAME OVER")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(.red)

                // Score
                VStack(spacing: 4) {
                    Text("\(gameState.dracmas)")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.yellow)
                        .contentTransition(.numericText())

                    Text("DRACMAS")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    statCell(value: "\(gameState.monstrosDestruidos)", label: "Abates")
                    statCell(value: "\(gameState.bossesDestruidos)", label: "Bosses")
                    statCell(value: formattedTime, label: "Tempo")
                    statCell(value: "\(gameState.highScore)", label: "Recorde")
                }

                // Restart Button — native Liquid Glass button style
                Button {
                    gameState.restart()
                } label: {
                    Text("JOGAR NOVAMENTE")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.glass)
                .tint(.green)
            }
            .padding(28)
            .frame(maxWidth: 340)
            .glassEffect(.regular, in: .rect(cornerRadius: 30))
        }
    }

    // MARK: - Helpers

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
    }

    private var formattedTime: String {
        let mins = Int(gameState.tempoDeJogo) / 60
        let secs = Int(gameState.tempoDeJogo) % 60
        return "\(mins)m \(String(format: "%02d", secs))s"
    }
}
