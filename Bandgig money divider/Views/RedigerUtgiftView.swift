import SwiftUI
import PhotosUI

struct RedigerUtgiftView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var utgift: Utgift
    let band: Band
    
    @State private var beskrivelse: String
    @State private var beløpText: String
    @State private var beløp: Double
    @State private var harKvittering: Bool
    @State private var valgtMedlem: Medlem
    @State private var kvitteringBildeNavn: String?
    @State private var visKamera = false
    @State private var visKameraValg = false
    @State private var visKameraIkkeTilgjengeligAlert = false
    @State private var valgtBilde: PhotosPickerItem?
    
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
        self._kvitteringBildeNavn = State(initialValue: utgiftVerdi.kvitteringBildeNavn)
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
        nyUtgift.harKvittering = harKvittering || kvitteringBildeNavn != nil
        nyUtgift.medlem = valgtMedlem
        nyUtgift.kvitteringBildeNavn = kvitteringBildeNavn
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
            }
            
            Section(header: Text("Kvittering (valgfritt)")) {
                HStack {
                    if let kvitteringBildeNavn = kvitteringBildeNavn {
                        kvitteringBilde(for: kvitteringBildeNavn)
                    }
                    
                    Spacer()
                    
                    kameraKnapp
                    bildeVelgerKnapp
                }
                .confirmationDialog("Velg kilde", isPresented: $visKameraValg) {
                    Button("Ta bilde") {
                        visKamera = true
                    }
                    PhotosPicker(selection: $valgtBilde,
                                matching: .images) {
                        Text("Velg fra bibliotek")
                    }
                }
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
        .sheet(isPresented: $visKamera) {
            CameraView(bildeNavn: $kvitteringBildeNavn)
        }
        .alert("Kamera ikke tilgjengelig", isPresented: $visKameraIkkeTilgjengeligAlert) {
            Button("OK", role: .cancel) { }
        }
        .onChange(of: valgtBilde) { _, newValue in
            handleValgtBildeEndring()
        }
    }
    
    private var kameraKnapp: some View {
        Button(action: {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                visKameraValg = true
            } else {
                visKameraIkkeTilgjengeligAlert = true
            }
        }) {
            Image(systemName: "camera.fill")
                .foregroundColor(.blue)
        }
    }
    
    private var bildeVelgerKnapp: some View {
        PhotosPicker(selection: $valgtBilde,
                    matching: .images) {
            Image(systemName: "photo.fill")
                .foregroundColor(.blue)
        }
    }
    
    private func kvitteringBilde(for bildeNavn: String) -> some View {
        let bildePath = getDocumentsDirectory().appendingPathComponent(bildeNavn)
        if let uiImage = UIImage(contentsOfFile: bildePath.path()) {
            return Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
        return Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
    }
    
    private func handleValgtBildeEndring() {
        Task {
            do {
                if let valgtBilde = valgtBilde,
                   let data = try await valgtBilde.loadTransferable(type: Data.self) {
                    let bildeNavn = UUID().uuidString + ".jpg"
                    let url = getDocumentsDirectory().appendingPathComponent(bildeNavn)
                    try data.write(to: url)
                    
                    // Verifiser at bildet ble lagret
                    if FileManager.default.fileExists(atPath: url.path()) {
                        await MainActor.run {
                            self.kvitteringBildeNavn = bildeNavn
                            self.valgtBilde = nil  // Nullstill valgt bilde
                            self.harKvittering = true
                        }
                    }
                }
            } catch {
                print("Feil ved lagring av bilde: \(error)")
                // TODO: Vis feilmelding til bruker
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
