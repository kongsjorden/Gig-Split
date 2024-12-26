import Foundation

struct Utgift: Identifiable, Codable {
    let id: UUID
    var medlem: Medlem
    var beskrivelse: String
    var beløp: Double
    var harKvittering: Bool
    
    init(id: UUID = UUID(), medlem: Medlem, beskrivelse: String, beløp: Double, harKvittering: Bool = false) {
        self.id = id
        self.medlem = medlem
        self.beskrivelse = beskrivelse
        self.beløp = beløp
        self.harKvittering = harKvittering
    }
}