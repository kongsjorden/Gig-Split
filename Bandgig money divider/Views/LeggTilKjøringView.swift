import SwiftUI

struct LeggTilKjøringView: View {
    @Environment(\.dismiss) var dismiss
    let band: Band
    let onSave: (KjøringDetalj) -> Void
    
    @State private var valgtMedlem: Medlem?
    @State private var kilometer = ""
    
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
                        Text("\(Double(kilometer) ?? 0 * medlem.kjøregodtgjørelse, specifier: "%.2f") kr")
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
                       let antallKm = Double(kilometer) {
                        let kjøring = KjøringDetalj(
                            medlem: medlem,
                            kilometer: antallKm
                        )
                        onSave(kjøring)
                        dismiss()
                    }
                }
                .disabled(valgtMedlem == nil || kilometer.isEmpty)
            }
        }
    }
}