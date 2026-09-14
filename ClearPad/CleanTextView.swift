import SwiftUI

struct CleanTextView: View {
    let testoOriginale: String
    let onConferma: (String) -> Void

    @State private var removeEmpty = false
    @State private var reduceEmpty = false
    @State private var removeSpacesOnly = false
    @State private var removeInvisible = false
    @State private var normalizeSpaces = false

    @State private var previewCleaned: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // Opzioni
                Form {
                    Toggle("Rimuovi righe vuote", isOn: $removeEmpty)
                    Toggle("Riduci righe vuote multiple", isOn: $reduceEmpty)
                    Toggle("Rimuovi righe con solo spazi/tab", isOn: $removeSpacesOnly)
                    Toggle("Rimuovi caratteri invisibili", isOn: $removeInvisible)
                    Toggle("Normalizza spazi doppi", isOn: $normalizeSpaces)
                }
                .onChange(of: removeEmpty) { _ in aggiornaAnteprima() }
                .onChange(of: reduceEmpty) { _ in aggiornaAnteprima() }
                .onChange(of: removeSpacesOnly) { _ in aggiornaAnteprima() }
                .onChange(of: removeInvisible) { _ in aggiornaAnteprima() }
                .onChange(of: normalizeSpaces) { _ in aggiornaAnteprima() }

                // Anteprima
                VStack(alignment: .leading) {
                    Text("Anteprima pulita:")
                        .font(.headline)

                    TextEditor(text: .constant(previewCleaned))
                        .frame(height: 200)
                        .border(.gray)
                }
                .padding(.horizontal)

                // Pulsante conferma
                Button("Applica pulizia") {
                    let cleaned = pulisciTesto(testoOriginale)
                    onConferma(cleaned)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)

                Spacer()
            }
            .navigationTitle("Pulizia testo")
            .onAppear {
                aggiornaAnteprima()
            }
        }
    }

    // LOGICA DI PULIZIA (versione Swift)
    private func pulisciTesto(_ text: String) -> String {
        var lines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        var testo = text

        // 1️⃣ Rimuovi caratteri invisibili
        if removeInvisible {
            testo = testo.replacingOccurrences(of: "\u{200B}", with: "")
            testo = testo.replacingOccurrences(of: "\u{00A0}", with: " ")
            lines = testo.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        }

        // 2️⃣ Normalizza spazi doppi
        if normalizeSpaces {
            lines = lines.map { $0.replacingOccurrences(of: " {2,}", with: " ", options: .regularExpression) }
        }

        // 3️⃣ Rimuovi righe con solo spazi/tab
        if removeSpacesOnly {
            lines = lines.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        }

        // 4️⃣ Rimuovi righe vuote
        if removeEmpty {
            lines = lines.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        }

        // 5️⃣ Riduci righe vuote multiple
        if reduceEmpty {
            var cleaned: [String] = []
            var lastEmpty = false

            for line in lines {
                if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if !lastEmpty {
                        cleaned.append("")
                    }
                    lastEmpty = true
                } else {
                    cleaned.append(line)
                    lastEmpty = false
                }
            }

            lines = cleaned
        }

        return lines.joined(separator: "\n")
    }

    private func aggiornaAnteprima() {
        previewCleaned = pulisciTesto(testoOriginale)
    }
}