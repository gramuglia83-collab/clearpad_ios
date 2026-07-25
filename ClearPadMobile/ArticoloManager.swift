import Foundation

struct Articolo: Identifiable, Codable {
    let id: UUID
    let titolo: String
    let contenuto: String
    let data: Date
}

class ArticoloManager {
    
    private static let fileName = "articoli.json"
    
    // Percorso del file JSON dove vengono salvati gli articoli
    private static var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: - Carica articoli salvati
    static func caricaArticoli() -> [Articolo] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let articoli = try JSONDecoder().decode([Articolo].self, from: data)
            return articoli
        } catch {
            print("Errore nel caricamento degli articoli: \(error)")
            return []
        }
    }
    
    // MARK: - Salva un nuovo articolo
    static func salvaArticolo(titolo: String, contenuto: String) {
        var articoli = caricaArticoli()
        
        let nuovo = Articolo(
            id: UUID(),
            titolo: titolo,
            contenuto: contenuto,
            data: Date()
        )
        
        articoli.append(nuovo)
        
        do {
            let data = try JSONEncoder().encode(articoli)
            try data.write(to: fileURL)
        } catch {
            print("Errore nel salvataggio dell'articolo: \(error)")
        }
    }
    
    // MARK: - Elimina un articolo
    static func eliminaArticolo(id: UUID) {
        var articoli = caricaArticoli()
        articoli.removeAll { $0.id == id }
        
        do {
            let data = try JSONEncoder().encode(articoli)
            try data.write(to: fileURL)
        } catch {
            print("Errore nell'eliminazione dell'articolo: \(error)")
        }
    }
}