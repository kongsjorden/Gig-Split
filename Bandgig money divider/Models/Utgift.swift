import Foundation

struct Utgift: Identifiable, Codable {
    let id: UUID
    let medlem: Medlem
    let beskrivelse: String
    let beløp: Double
    var harKvittering: Bool
    
    init(id: UUID = UUID(), medlem: Medlem, beskrivelse: String, beløp: Double, harKvittering: Bool = false) {
        self.id = id
        self.medlem = medlem
        self.beskrivelse = beskrivelse
        self.beløp = beløp
        self.harKvittering = harKvittering
    }
}