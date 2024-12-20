import Foundation

struct KjøringDetalj: Identifiable, Codable {
    let id: UUID
    let medlem: Medlem
    let kilometer: Double
    var beløp: Double {
        return kilometer * medlem.kjøregodtgjørelse
    }
    var kilometerKjørt: Double {
        return kilometer
    }
    
    init(id: UUID = UUID(), medlem: Medlem, kilometer: Double) {
        self.id = id
        self.medlem = medlem
        self.kilometer = kilometer
    }
}