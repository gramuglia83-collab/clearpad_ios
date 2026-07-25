import SwiftUI

struct EditorView: View {
    @State private var text: String = ""

    // Stato per la correzione interattiva
    @State private var mostraCorrezioneInterattiva = false
    @State private var testoDaCorreggere = ""

    // Feedback VoiceOver
    @State private var voiceOverFeedback: String = ""

    var body: some View {
        VStack(spacing: 20) {

            // Area di testo
            TextEditor(text: $text)
                .padding()
                .accessibilityLabel("Area di testo")
                .accessibilityHint("Scrivi o modifica il contenuto del documento")
                .accessibilityValue(text.isEmpty ? "Vuoto" : "Contenuto presente")
                .accessibilitySortPriority(3)

            // Pulsante di correzione interattiva (solo se c'è testo)
            if !text.isEmpty {
                Button("Correggi testo") {
                    testoDaCorreggere = text
                    mostraCorrezioneInterattiva = true
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Correggi testo")
                .accessibilityHint("Analizza e corregge automaticamente il testo scritto")
                .accessibilitySortPriority(2)
            }

            // Pulsante di salvataggio
            Button("Salva documento") {
                // logica futura
            }
            .padding()
            .accessibilityLabel("Salva documento")
            .accessibilityHint("Salva il testo scritto")
            .accessibilitySortPriority(1)
        }
        .navigationTitle("Editor")
        .accessibilitySortPriority(10)

        // Apertura della vista di correzione
        .sheet(isPresented: $mostraCorrezioneInterattiva) {
            CorrezioneInterattivaView(
                testoOriginale: testoDaCorreggere,
                onConferma: { testoCorretto in
                    self.text = testoCorretto

                    // Feedback VoiceOver
                    if trovaErrori(in: testoCorretto).isEmpty {
                        voiceOverFeedback = "Nessun errore rilevato"
                    } else {
                        voiceOverFeedback = "Correzione applicata"
                    }

                    UIAccessibility.post(notification: .announcement, argument: voiceOverFeedback)
                }
            )
        }
    }
}