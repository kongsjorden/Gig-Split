import SwiftUI

struct NyttMedlemView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (Medlem) -> Void
    
    @State private var navn = ""
    @State private var telefonnummer = ""
    @State private var epost = ""
    @State private var kontonummer = ""
    @State private var vipps = ""
    @State private var harKjøregodtgjørelse = false
    @State private var kjøregodtgjørelseSats: Double
    
    init(defaultKjøregodtgjørelse: Double, onSave: @escaping (Medlem) -> Void) {
        self._kjøregodtgjørelseSats = State(initialValue: defaultKjøregodtgjørelse)
        self.onSave = onSave
    }
    
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case navn, telefon, epost, konto, vipps, sats
    }
    
    private func lagreMedlem() {
        let nyttMedlem = Medlem(
            navn: navn,
            telefonnummer: telefonnummer,
            epost: epost,
            kontonummer: kontonummer,
            vipps: vipps,
            kjøregodtgjørelse: harKjøregodtgjørelse ? kjøregodtgjørelseSats : 0
        )
        
        onSave(nyttMedlem)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(Strings.Band.memberDetails)) {
                    TextField(Strings.Band.name, text: $navn)
                        .focused($focusedField, equals: .navn)
                        .textContentType(.name)
                    
                    TextField(Strings.Band.phoneNumber, text: $telefonnummer)
                        .focused($focusedField, equals: .telefon)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                    
                    TextField(Strings.Band.email, text: $epost)
                        .focused($focusedField, equals: .epost)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text(Strings.Band.paymentInfo)) {
                    TextField(Strings.Band.accountNumber, text: $kontonummer)
                        .focused($focusedField, equals: .konto)
                        .keyboardType(.numberPad)
                    
                    TextField(Strings.Band.vipps, text: $vipps)
                        .focused($focusedField, equals: .vipps)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text(Strings.Band.mileageCompensation)) {
                    Toggle(Strings.Gig.driving, isOn: $harKjøregodtgjørelse)
                    
                    if harKjøregodtgjørelse {
                        HStack {
                            Text(Strings.Band.ratePerKm)
                            Spacer()
                            TextField("0.0", value: $kjøregodtgjørelseSats, formatter: NumberFormatter())
                                .focused($focusedField, equals: .sats)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("kr/km")
                        }
                    }
                }
            }
            .navigationTitle(Strings.Band.addMember)
            .navigationBarItems(
                leading: Button(Strings.General.cancel) {
                    dismiss()
                },
                trailing: Button(Strings.General.save) {
                    lagreMedlem()
                }
                .disabled(navn.isEmpty)
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Ferdig") {
                        focusedField = nil
                    }
                }
            }
        }
    }
}