import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {

                // Editor di testo
                NavigationLink("Editor di testo") {
                    EditorView()
                }
                .accessibilityLabel("Editor di testo")
                .accessibilityHint("Apri l'editor per scrivere o modificare note")
                .accessibilitySortPriority(3)

                // Articoli condivisi (nuova voce approvabile)
                NavigationLink("Articoli condivisi") {
                    ArticoliListView()
                }
                .accessibilityLabel("Articoli condivisi")
                .accessibilityHint("Visualizza gli articoli condivisi da altre app in modalità sola lettura")
                .accessibilitySortPriority(2)

                // Gestione PDF
                NavigationLink("Gestione PDF") {
                    PDFView()
                }
                .accessibilityLabel("Gestione PDF")
                .accessibilityHint("Apri e analizza documenti PDF")
                .accessibilitySortPriority(1)
            }
            .navigationTitle("ClearPad Mobile")
            .accessibilitySortPriority(10)
        }
    }
}