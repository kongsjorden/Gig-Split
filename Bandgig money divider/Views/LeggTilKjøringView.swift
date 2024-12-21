import SwiftUI

struct LeggTilKjøringView: View {
    let band: Band
    let onSave: (KjøringDetalj) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var valgtMedlem: Medlem? = nil
    @State private var kilometer: Double = 0.0
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case kilometer
    }
    
    var body: some View {
        Form {
            Section(header: Text(Strings.Driving.member)) {
                Picker(Strings.Driving.selectMember, selection: $valgtMedlem) {
                    Text(Strings.Driving.selectMember)
                        .tag(Optional<Medlem>.none)
                    ForEach(band.medlemmer) { medlem in
                        Text(medlem.navn).tag(Optional(medlem))
                    }
                }
            }
            
            Section(header: Text(Strings.Driving.distance)) {
                HStack {
                    TextField(Strings.Driving.kilometers, value: $kilometer, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .kilometer)
                        .multilineTextAlignment(.trailing)
                    Text("km")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(Strings.Driving.addDriving)
        .navigationBarItems(
            leading: Button(Strings.Common.cancel) {
                dismiss()
            },
            trailing: Button(Strings.Common.save) {
                if let medlem = valgtMedlem {
                    let kjøring = KjøringDetalj(medlem: medlem, kilometer: kilometer)
                    onSave(kjøring)
                    dismiss()
                }
            }
            .disabled(valgtMedlem == nil || kilometer <= 0)
        )
    }
}