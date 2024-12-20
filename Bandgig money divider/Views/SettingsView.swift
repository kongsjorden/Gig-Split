import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedCurrency") private var selectedCurrency = Currency.nok.rawValue
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(Strings.Settings.defaults)) {
                    Picker(Strings.Settings.currency, selection: $selectedCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text("\(currency.name) (\(currency.symbol))")
                                .tag(currency.rawValue)
                        }
                    }
                }
                
                Section(header: Text(Strings.Settings.about)) {
                    HStack {
                        Text(Strings.Settings.version)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(Strings.Settings.settings)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Strings.General.done) {
                        dismiss()
                    }
                }
            }
        }
    }
}