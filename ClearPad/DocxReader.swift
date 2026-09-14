import Foundation
import ZIPFoundation

struct DocxReader {

    /// Estrae il testo da un file DOCX
    static func estraiTesto(from url: URL) -> String? {

        // 1️⃣ Apriamo il file ZIP (DOCX)
        guard let archive = Archive(url: url, accessMode: .read) else {
            print("Errore: impossibile aprire il file DOCX come ZIP")
            return nil
        }

        // 2️⃣ Cerchiamo il file principale del documento
        guard let entry = archive["word/document.xml"] else {
            print("Errore: document.xml non trovato nel DOCX")
            return nil
        }

        // 3️⃣ Estraiamo il contenuto XML
        var xmlData = Data()
        do {
            _ = try archive.extract(entry) { data in
                xmlData.append(data)
            }
        } catch {
            print("Errore estrazione XML: \(error)")
            return nil
        }

        // 4️⃣ Convertiamo XML → testo semplice
        guard let xmlString = String(data: xmlData, encoding: .utf8) else {
            print("Errore: impossibile convertire XML in stringa")
            return nil
        }

        // 5️⃣ Pulizia XML → testo
        let testoPulito = pulisciXML(xmlString)

        return testoPulito
    }

    /// Converte il contenuto XML del DOCX in testo semplice
    private static func pulisciXML(_ xml: String) -> String {

        var testo = xml

        // Rimuove tag XML
        testo = testo.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)

        // Rimuove entità HTML comuni
        let replacements: [String: String] = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'",
            "&nbsp;": " "
        ]

        for (key, value) in replacements {
            testo = testo.replacingOccurrences(of: key, with: value)
        }

        // Normalizza spazi multipli
        testo = testo.replacingOccurrences(of: " {2,}", with: " ", options: .regularExpression)

        // Normalizza righe vuote
        let righe = testo.split(separator: "\n", omittingEmptySubsequences: false)
        let pulite = righe.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        return pulite.joined(separator: "\n")
    }
}