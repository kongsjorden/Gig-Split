import SwiftUI

struct RedigerMedlemView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var medlem: Medlem
    
    @State private var navn: String
    @State private var harKjøregodtgjørelse: Bool
    @State private var kjøregodtgjørelseSats: Double
    
    init(medlem: Binding<Medlem>) {
        self._medlem = medlem
        _navn = State(initialValue: medlem.wrappedValue.navn)
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
                Section {
                    TextField(Strings.Band.name, text: $navn)
                    
                    Toggle(Strings.Gig.driving, isOn: $harKjøregodtgjørelse)
                    
                    if harKjøregodtgjørelse {
                        HStack {
                            Text("Rate per km:")
                            TextField("Rate", value: $kjøregodtgjørelseSats, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
            }
            .navigationTitle(Strings.Band.editMember)
            .safeAreaInset(edge: .top, spacing: 0) {
                Text(Strings.Band.editMember)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.clear)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.General.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Strings.General.save) {
                        medlem.navn = navn
                        medlem.kjøregodtgjørelse = harKjøregodtgjørelse ? kjøregodtgjørelseSats : 0
                        dismiss()
                    }
                    .disabled(navn.isEmpty)
                }
            }
        }
    }
}