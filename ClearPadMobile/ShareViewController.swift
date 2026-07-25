import UIKit
import Social
import SwiftUI

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            completeRequest()
            return
        }

        guard let attachments = extensionItem.attachments else {
            completeRequest()
            return
        }

        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier("public.text") {
                provider.loadItem(forTypeIdentifier: "public.text", options: nil) { (item, error) in
                    
                    if let error = error {
                        print("Errore nel caricamento del testo: \(error.localizedDescription)")
                        self.completeRequest()
                        return
                    }

                    guard let text = item as? String else {
                        print("Il contenuto condiviso non è testo.")
                        self.completeRequest()
                        return
                    }

                    let titolo = self.generaTitolo(text)
                    ArticoloManager.salvaArticolo(titolo: titolo, contenuto: text)

                    self.completeRequest()
                }
                return
            }
        }

        // Nessun contenuto compatibile trovato
        completeRequest()
    }

    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    private func generaTitolo(_ testo: String) -> String {
        let primaLinea = testo.split(separator: "\n").first ?? "Articolo"
        let titolo = String(primaLinea).trimmingCharacters(in: .whitespacesAndNewlines)
        return titolo.isEmpty ? "Articolo" : titolo
    }
}