import SwiftUI

struct CurrencyText: View {
    let amount: Double
    @AppStorage("selectedCurrency") private var selectedCurrency = Currency.nok.rawValue
    
    var currency: Currency {
        Currency(rawValue: selectedCurrency) ?? .nok
    }
    
    private var formattedAmount: String {
        guard !amount.isNaN && !amount.isInfinite else { return "0" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }
    
    var body: some View {
        switch currency {
        case .nok:
            Text("\(formattedAmount) \(currency.symbol)")
        case .usd, .eur:
            Text("\(currency.symbol)\(formattedAmount)")
        }
    }
}

extension View {
    func currencyText(_ amount: Double) -> some View {
        CurrencyText(amount: amount)
    }
}