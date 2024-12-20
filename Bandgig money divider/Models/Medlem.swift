import Foundation

struct Medlem: Identifiable, Codable, Hashable {
    var id = UUID()
    var navn: String
    var telefonnummer: String
    var epost: String
    var kontonummer: String
    var vipps: String
    var kjøregodtgjørelse: Double
    
    init(
        id: UUID = UUID(),
        navn: String,
        telefonnummer: String = "",
        epost: String = "",
        kontonummer: String = "",
        vipps: String = "",
        kjøregodtgjørelse: Double = 0
    ) {
        self.id = id
        self.navn = navn
        self.telefonnummer = telefonnummer
        self.epost = epost
        self.kontonummer = kontonummer
        self.vipps = vipps
        self.kjøregodtgjørelse = kjøregodtgjørelse
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Medlem, rhs: Medlem) -> Bool {
        lhs.id == rhs.id
    }
}