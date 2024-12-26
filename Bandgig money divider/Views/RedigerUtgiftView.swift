import SwiftUI

struct RedigerUtgiftView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var utgift: Utgift
    let band: Band
    
    @State private var beskrivelse: String
    @State private var beløpText: String
    @State private var beløp: Double
    @State private var harKvittering: Bool
    @State private var valgtMedlem: Medlem
    
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
    
    init(utgift: Binding<Utgift>, band: Band) {
        self._utgift = utgift
        self.band = band
        let utgiftVerdi = utgift.wrappedValue
        self._beskrivelse = State(initialValue: utgiftVerdi.beskrivelse)
        self._beløp = State(initialValue: utgiftVerdi.beløp)
        self._beløpText = State(initialValue: String(format: "%.0f", utgiftVerdi.beløp))
        self._harKvittering = State(initialValue: utgiftVerdi.harKvittering)
        self._valgtMedlem = State(initialValue: utgiftVerdi.medlem)
    }
    
    private func formatNumber(_ number: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    private func parseNumber(_ text: String) -> Double {
        let cleanedText = text.replacingOccurrences(of: " ", with: "")
        return Double(cleanedText) ?? 0
    }
    
    private func lagreEndringer() {
        var nyUtgift = $utgift.wrappedValue
        nyUtgift.beskrivelse = beskrivelse
        nyUtgift.beløp = beløp
        nyUtgift.harKvittering = harKvittering
        nyUtgift.medlem = valgtMedlem
        $utgift.wrappedValue = nyUtgift
        dismiss()
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Beskrivelse", text: $beskrivelse)
                
                HStack {
                    Text("Beløp")
                    Spacer()
                    TextField("0", text: $beløpText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 120)
                        .onChange(of: beløpText) { oldValue, newValue in
                            let number = parseNumber(newValue)
                            beløp = number
                            beløpText = formatNumber(number)
                        }
                    Text("kr")
                }
                
                Picker("Medlem", selection: $valgtMedlem) {
                    ForEach(band.medlemmer) { medlem in
                        Text(medlem.navn).tag(medlem)
                    }
                }
                
                Toggle("Har kvittering", isOn: $harKvittering)
            }
        }
        .navigationTitle("Rediger utgift")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Lagre") {
                    lagreEndringer()
                }
            }
        }
    }
}
