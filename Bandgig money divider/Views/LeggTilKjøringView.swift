import SwiftUI

struct LeggTilKjøringView: View {
    @Environment(\.dismiss) var dismiss
    let band: Band
    let onSave: (KjøringDetalj) -> Void
    
    @State private var valgtMedlem: Medlem?
    @State private var kilometer = ""
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    private func formatNumber(_ number: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    private func parseNumber(_ text: String) -> Double? {
        let cleanedText = text.replacingOccurrences(of: " ", with: "")
        return Double(cleanedText)
    }
    
    var body: some View {
        Form {
            Section(header: Text("KJØREINFORMASJON")) {
                Picker("Velg medlem", selection: $valgtMedlem) {
                    Text("Velg medlem").tag(nil as Medlem?)
                    ForEach(band.medlemmer.filter { $0.kjøregodtgjørelse > 0 }) { medlem in
                        Text(medlem.navn).tag(medlem as Medlem?)
                    }
                }
                
                TextField("Antall kilometer", text: $kilometer)
                    .keyboardType(.numberPad)
                    .onChange(of: kilometer) { oldValue, newValue in
                        if let number = parseNumber(newValue) {
                            kilometer = formatNumber(number)
                        }
                    }
            }
            
            if let medlem = valgtMedlem {
                Section(header: Text("BEREGNET BELØP")) {
                    HStack {
                        Text("Kjøregodtgjørelse")
                        Spacer()
                        Text("\(medlem.kjøregodtgjørelse, specifier: "%.2f") kr/km")
                    }
                    
                    HStack {
                        Text("Totalt beløp")
                        Spacer()
                        if let antallKm = parseNumber(kilometer) {
                            Text("\(antallKm * medlem.kjøregodtgjørelse, specifier: "%.2f") kr")
                        } else {
                            Text("0.00 kr")
                        }
                    }
                }
            }
        }
        .customNavigationTitle("Legg til kjøring")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Avbryt") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Lagre") {
                    if let medlem = valgtMedlem,
                       let antallKm = parseNumber(kilometer) {
                        let kjøring = KjøringDetalj(
                            medlem: medlem,
                            kilometer: antallKm
                        )
                        onSave(kjøring)
                        dismiss()
                    }
                }
                .disabled(valgtMedlem == nil || kilometer.isEmpty || parseNumber(kilometer) == nil)
            }
        }
    }
}