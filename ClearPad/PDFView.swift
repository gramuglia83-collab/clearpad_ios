import SwiftUI
import PDFKit

struct PDFView: View {
    @State private var showPicker = false
    @State private var pdfDocument: PDFDocument?

    var body: some View {
        VStack {
            Button("Seleziona PDF") {
                showPicker = true
            }
            .accessibilityLabel("Seleziona PDF")
            .accessibilityHint("Apri un documento PDF dal dispositivo")

            if let pdf = pdfDocument {
                PDFKitView(document: pdf)
                    .accessibilityLabel("Visualizzatore PDF")
                    .accessibilityHint("Documento PDF caricato")
            } else {
                Text("Nessun PDF selezionato")
                    .accessibilityLabel("Nessun PDF selezionato")
            }
        }
        .navigationTitle("PDF")
        .sheet(isPresented: $showPicker) {
            DocumentPicker(pdfDocument: $pdfDocument)
        }
    }
}