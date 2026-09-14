import SwiftUI

struct ArticoliListView: View {
    @State private var articoli: [Articolo] = ArticoloManager.caricaArticoli()

    var body: some View {
        VStack {
            
            // Pulsante manuale per aggiornare la lista
            Button("Aggiorna lista") {
                articoli = ArticoloManager.caricaArticoli()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .accessibilityLabel("Aggiorna lista")
            .accessibilityHint("Ricarica gli articoli salvati")
            .accessibilitySortPriority(5)

            List {
                if articoli.isEmpty {
                    Text("Nessun articolo condiviso")
                        .accessibilityLabel("Nessun articolo condiviso")
                        .accessibilityHint("Condividi un articolo da un'altra app per visualizzarlo qui")
                        .accessibilitySortPriority(1)
                } else {
                    ForEach(articoli) { articolo in
                        NavigationLink(articolo.titolo) {
                            SharedArticleView(receivedText: articolo.contenuto)
                        }
                        .accessibilityLabel(articolo.titolo)
                        .accessibilityHint("Apri l'articolo condiviso in modalità sola lettura")
                        .accessibilityValue(formatoData(articolo.data))
                        .accessibilitySortPriority(3)
                    }
                    .onDelete(perform: eliminaArticolo)
                }
            }
            .onAppear {
                // Aggiornamento automatico quando la vista appare
                articoli = ArticoloManager.caricaArticoli()
            }
        }
        .navigationTitle("Articoli condivisi")
        .accessibilityLabel("Elenco articoli condivisi")
        .accessibilityHint("Lista degli articoli salvati da altre app")
        .accessibilitySortPriority(10)
    }

    // MARK: - Elimina articolo dalla lista e dal file JSON
    private func eliminaArticolo(at offsets: IndexSet) {
        for index in offsets {
            let articolo = articoli[index]
            ArticoloManager.eliminaArticolo(id: articolo.id)
        }
        articoli = ArticoloManager.caricaArticoli()
    }

    // MARK: - Formatta la data per VoiceOver
    private func formatoData(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateStyle = .medium
        return formatter.string(from: data)
    }
}