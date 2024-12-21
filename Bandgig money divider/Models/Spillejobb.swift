import Foundation

struct Spillejobb: Identifiable, Codable, Hashable {
    var id = UUID()
    var sted: String
    var dato: Date
    var bruttoInntekt: Double
    var paLeie: Double
    var kjøring: [KjøringDetalj]
    var andreUtgifter: [Utgift]
    
    var kjøringTotalt: Double {
        kjøring.reduce(into: 0.0) { total, detalj in
            total += detalj.kilometer * detalj.medlem.kjøregodtgjørelse
        }
    }
    
    var andreUtgifterTotalt: Double {
        andreUtgifter.reduce(into: 0.0) { total, utgift in
            total += utgift.beløp
        }
    }
    
    var totaleUtgifter: Double {
        paLeie + kjøringTotalt + andreUtgifterTotalt
    }
    
    var overskudd: Double {
        bruttoInntekt - totaleUtgifter
    }
    
    func fordelOverskudd(mellom medlemmer: [Medlem]) -> [(medlem: Medlem, beløp: Double)] {
        guard !medlemmer.isEmpty else { return [] }
        let beløpPerMedlem = overskudd / Double(medlemmer.count)
        return medlemmer.map { medlem in
            (medlem: medlem, beløp: beløpPerMedlem)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Spillejobb, rhs: Spillejobb) -> Bool {
        lhs.id == rhs.id
    }
}