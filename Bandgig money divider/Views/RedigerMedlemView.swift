import SwiftUI

struct RedigerMedlemView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var medlem: Medlem
    
    @State private var navn: String
    @State private var telefonnummer: String
    @State private var epost: String
    @State private var kontonummer: String
    @State private var vipps: String
    @State private var harKjøregodtgjørelse: Bool
    @State private var kjøregodtgjørelseSats: Double
    
    init(medlem: Binding<Medlem>) {
        self._medlem = medlem
        _navn = State(initialValue: medlem.wrappedValue.navn)
        _telefonnummer = State(initialValue: medlem.wrappedValue.telefonnummer ?? "")
        _epost = State(initialValue: medlem.wrappedValue.epost ?? "")
        _kontonummer = State(initialValue: medlem.wrappedValue.kontonummer ?? "")
        _vipps = State(initialValue: medlem.wrappedValue.vipps ?? "")
        _harKjøregodtgjørelse = State(initialValue: medlem.wrappedValue.kjøregodtgjørelse > 0)
        _kjøregodtgjørelseSats = State(initialValue: medlem.wrappedValue.kjøregodtgjørelse > 0 ? medlem.wrappedValue.kjøregodtgjørelse : 3.50)
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personlig informasjon") {
                    TextField(Strings.Band.name, text: $navn)
                    TextField("Telefonnummer", text: $telefonnummer)
                        .keyboardType(.phonePad)
                    TextField("E-post", text: $epost)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section("Betalingsinformasjon") {
                    TextField("Kontonummer", text: $kontonummer)
                        .keyboardType(.numberPad)
                    TextField("Vipps", text: $vipps)
                        .keyboardType(.phonePad)
                }
                
                Section("Kjøregodtgjørelse") {
                    Toggle("Kjøring", isOn: $harKjøregodtgjørelse)
                    
                    if harKjøregodtgjørelse {
                        HStack {
                            Text("Rate per km:")
                            TextField("Rate", value: $kjøregodtgjørelseSats, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            .navigationTitle(Strings.Band.editMember)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.Common.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Strings.Common.save) {
                        medlem.navn = navn
                        medlem.telefonnummer = telefonnummer.isEmpty ? nil : telefonnummer
                        medlem.epost = epost.isEmpty ? nil : epost
                        medlem.kontonummer = kontonummer.isEmpty ? nil : kontonummer
                        medlem.vipps = vipps.isEmpty ? nil : vipps
                        medlem.kjøregodtgjørelse = harKjøregodtgjørelse ? kjøregodtgjørelseSats : 0.0
                        dismiss()
                    }
                    .disabled(navn.isEmpty)
                }
            }
        }
    }
}