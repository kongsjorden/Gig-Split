import Foundation

enum Currency: String, CaseIterable, Codable {
    case nok = "NOK"
    case usd = "USD"
    case eur = "EUR"
    
    var symbol: String {
        switch self {
        case .nok: return "kr"
        case .usd: return "$"
        case .eur: return "€"
        }
    }
    
    var name: String {
        switch self {
        case .nok: return "Norwegian Krone"
        case .usd: return "US Dollar"
        case .eur: return "Euro"
        }
    }
} 