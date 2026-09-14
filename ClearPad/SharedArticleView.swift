import SwiftUI

struct SharedArticleView: View {
    let receivedText: String
    @State private var saved: Bool = false

    var body: some View {
        VStack {
            
            // Testo in sola lettura
            ScrollView {
                Text(receivedText)
                    .padding()
                    .accessibilityLabel("Articolo condiviso")
                    .accessibilityHint("Modalità sola lettura, il testo non può essere modificato")
                    .accessibilityValue(receivedText.isEmpty ? "Vuoto" : "Contenuto presente")
                    .accessibilitySortPriority(3)
            }

            // Pulsante Salva articolo
            Button(saved ? "Articolo salvato" : "Salva articolo") {
                let titolo = generaTitolo(receivedText)
                ArticoloManager.salvaArticolo(titolo: titolo, contenuto: receivedText)
                saved = true
            }
            .padding()
            .accessibilityLabel(saved ? "Articolo già salvato" : "Salva articolo")
            .accessibilityHint("Salva il contenuto per leggerlo in futuro")
            .accessibilitySortPriority(1)
            .disabled(saved)
        }
        .navigationTitle("Articolo")
        .accessibilitySortPriority(10)
    }

    // Genera un titolo automatico dal contenuto
    private func generaTitolo(_ testo: String) -> String {
        let primaLinea = testo.split(separator: "\n").first ?? "Articolo"
        let titolo = String(primaLinea).trimmingCharacters(in: .whitespacesAndNewlines)
        return titolo.isEmpty ? "Articolo" : titolo
    }
}