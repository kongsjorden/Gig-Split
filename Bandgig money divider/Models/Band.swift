import Foundation
import Observation

@Observable
final class Band: Identifiable, Codable, Hashable {
    var id = UUID()
    var navn: String
    var medlemmer: [Medlem]
    var spillejobber: [Spillejobb]
    
    init(id: UUID = UUID(), navn: String, medlemmer: [Medlem] = [], spillejobber: [Spillejobb] = []) {
        self.id = id
        self.navn = navn
        self.medlemmer = medlemmer
        self.spillejobber = spillejobber
    }
    
    func leggTilMedlem(_ medlem: Medlem) {
        medlemmer.append(medlem)
        print("Medlem lagt til i Band-klassen. Antall nå: \(medlemmer.count)")
    }
    
    func fjernMedlem(at index: Int) {
        medlemmer.remove(at: index)
    }
    
    func leggTilSpillejobb(_ spillejobb: Spillejobb) {
        spillejobber.append(spillejobb)
    }
    
    func fjernSpillejobb(at index: Int) {
        spillejobber.remove(at: index)
    }
    
    // MARK: - Hashable
    static func == (lhs: Band, rhs: Band) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id, navn, medlemmer, spillejobber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        navn = try container.decode(String.self, forKey: .navn)
        medlemmer = try container.decode([Medlem].self, forKey: .medlemmer)
        spillejobber = try container.decode([Spillejobb].self, forKey: .spillejobber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(navn, forKey: .navn)
        try container.encode(medlemmer, forKey: .medlemmer)
        try container.encode(spillejobber, forKey: .spillejobber)
    }
}