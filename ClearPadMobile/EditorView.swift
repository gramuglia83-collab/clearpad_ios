import SwiftUI
import UniformTypeIdentifiers

struct EditorView: View {
    @State private var text: String = ""

    // Correzione interattiva
    @State private var mostraCorrezioneInterattiva = false
    @State private var testoDaCorreggere = ""

    // Pulizia testo
    @State private var mostraPuliziaTesto = false
    @State private var testoDaPulire = ""

    // Importazione file
    @State private var mostraImportazione = false

    // PDF
    @State private var mostraPDF = false
    @State private var pdfURL: URL?

    // Esportazione
    @State private var mostraEsportazione = false
    @State private var fileDaCondividere: URL?

    var body: some View {
        VStack {

            // Area di testo
            TextEditor(text: $text)
                .padding()

            // Pulsante Importa file
            if text.isEmpty {
                Button("Importa file") {
                    mostraImportazione = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }

            // Pulsante Salva documento
            Button("Salva documento") {
                // logica futura
            }
            .padding()

            // Pulsante Esporta TXT
            if !text.isEmpty {
                Button("Esporta TXT") {
                    esportaTXT()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }

            // Pulsante Esporta DOCX
            if !text.isEmpty {
                Button("Esporta DOCX") {
                    esportaDOCX()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }

            // Pulsante Correzione interattiva
            Button("Correzione interattiva") {
                testoDaCorreggere = text
                mostraCorrezioneInterattiva = true
            }
            .padding()

            // Pulsante Pulizia testo
            if !text.isEmpty {
                Button("Pulisci testo") {
                    testoDaPulire = text
                    mostraPuliziaTesto = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Editor")

        // Sheet correzione
        .sheet(isPresented: $mostraCorrezioneInterattiva) {
            CorrezioneInterattivaView(
                testoOriginale: testoDaCorreggere,
                onConferma: { testoCorretto in
                    self.text = testoCorretto
                }
            )
        }

        // Sheet pulizia
        .sheet(isPresented: $mostraPuliziaTesto) {
            CleanTextView(
                testoOriginale: testoDaPulire,
                onConferma: { testoPulito in
                    self.text = testoPulito
                }
            )
        }

        // Sheet PDF
        .sheet(isPresented: $mostraPDF) {
            if let url = pdfURL {
                PDFView(url: url)
            }
        }

        // Sheet esportazione
        .sheet(isPresented: $mostraEsportazione) {
            if let fileURL = fileDaCondividere {
                ShareSheet(activityItems: [fileURL])
            }
        }

        // Importazione file
        .fileImporter(
            isPresented: $mostraImportazione,
            allowedContentTypes: [
                UTType.plainText,
                UTType.pdf,
                UTType(filenameExtension: "docx")!
            ]
        ) { result in
            do {
                let url = try result.get()
                importaFile(url)
            } catch {
                print("Errore importazione file: \(error)")
            }
        }
    }

    // Importazione file
    private func importaFile(_ url: URL) {
        let ext = url.pathExtension.lowercased()

        switch ext {
        case "txt":
            importaTXT(url)

        case "pdf":
            pdfURL = url
            mostraPDF = true

        case "docx":
            if let testoEstratto = DocxReader.estraiTesto(from: url) {
                self.text = testoEstratto
            }

        default:
            break
        }
    }

    // Importazione TXT
    private func importaTXT(_ url: URL) {
        do {
            let contenuto = try String(contentsOf: url, encoding: .utf8)
            self.text = contenuto
        } catch {
            print("Errore lettura TXT: \(error)")
        }
    }

    // Esportazione TXT
    private func esportaTXT() {
        let nome = "documento.txt"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(nome)

        do {
            try text.write(to: url, atomically: true, encoding: .utf8)
            fileDaCondividere = url
            mostraEsportazione = true
        } catch {
            print("Errore esportazione TXT: \(error)")
        }
    }

    // Esportazione DOCX
    private func esportaDOCX() {
        if let url = DocxWriter.creaDocx(contenuto: text) {
            fileDaCondividere = url
            mostraEsportazione = true
        }
    }