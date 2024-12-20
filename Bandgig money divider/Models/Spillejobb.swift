import Foundation

struct Spillejobb: Identifiable, Codable, Hashable {
    var id = UUID()
    var sted: String
    var dato: Date
    var bruttoInntekt: Double
    var paLeie: Double
    var kjøring: [KjøringDetalj]
    var andreUtgifter: [Utgift]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Spillejobb, rhs: Spillejobb) -> Bool {
        lhs.id == rhs.id
    }
}