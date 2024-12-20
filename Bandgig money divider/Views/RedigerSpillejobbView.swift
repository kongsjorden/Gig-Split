import SwiftUI

struct RedigerSpillejobbView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var spillejobb: Spillejobb
    let band: Band
    
    @State private var sted: String
    @State private var dato: Date
    @State private var bruttoInntekt: Double
    @State private var paLeie: Double
    @State private var kjøring: [KjøringDetalj]
    @State private var andreUtgifter: [Utgift]
    @State private var visLeggTilKjøring = false
    @State private var visLeggTilUtgift = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case sted, bruttoInntekt, paLeie
    }
    
    init(spillejobb: Binding<Spillejobb>, band: Band) {
        self._spillejobb = spillejobb
        self.band = band
        self._sted = State(initialValue: spillejobb.wrappedValue.sted)
        self._dato = State(initialValue: spillejobb.wrappedValue.dato)
        self._bruttoInntekt = State(initialValue: spillejobb.wrappedValue.bruttoInntekt)
        self._paLeie = State(initialValue: spillejobb.wrappedValue.paLeie)
        self._kjøring = State(initialValue: spillejobb.wrappedValue.kjøring)
        self._andreUtgifter = State(initialValue: spillejobb.wrappedValue.andreUtgifter)
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private func lagreEndringer() {
        spillejobb.sted = sted
        spillejobb.dato = dato
        spillejobb.bruttoInntekt = bruttoInntekt
        spillejobb.paLeie = paLeie
        spillejobb.kjøring = kjøring
        spillejobb.andreUtgifter = andreUtgifter
        
        // Oppdater spillejobben i band-objektet
        if let index = band.spillejobber.firstIndex(where: { $0.id == spillejobb.id }) {
            band.spillejobber[index] = spillejobb
        }
        
        dismiss()
    }
    
    var body: some View {
        Form {
            basicInfoSection
            economySection
            kjøringSection
            andreUtgifterSection
        }
        .navigationTitle(Strings.Gig.editGig)
        .navigationBarItems(
            leading: Button(Strings.General.cancel) {
                dismiss()
            },
            trailing: Button(Strings.General.save) {
                lagreEndringer()
            }
            .disabled(sted.isEmpty)
        )
        .sheet(isPresented: $visLeggTilKjøring) {
            NavigationStack {
                LeggTilKjøringView(band: band, onSave: { nyKjøring in
                    kjøring.append(nyKjøring)
                })
            }
        }
        .sheet(isPresented: $visLeggTilUtgift) {
            NavigationStack {
                LeggTilUtgiftView(band: band) { utgift in
                    andreUtgifter.append(utgift)
                }
            }
        }
        .toolbar {
            if focusedField != nil {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Ferdig") {
                        focusedField = nil
                    }
                }
            }
        }
    }
    
    private var basicInfoSection: some View {
        Section(header: Text(Strings.Gig.basicInfo)) {
            TextField(Strings.Gig.venue, text: $sted)
                .focused($focusedField, equals: .sted)
            DatePicker(Strings.Gig.date, selection: $dato, displayedComponents: [.date])
        }
    }
    
    private var economySection: some View {
        Section(header: Text(Strings.Gig.economy)) {
            VStack(alignment: .leading) {
                Text(Strings.Gig.grossIncome)
                HStack {
                    TextField("0", value: $bruttoInntekt, formatter: numberFormatter)
                        .focused($focusedField, equals: .bruttoInntekt)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("kr")
                }
            }
            
            VStack(alignment: .leading) {
                Text(Strings.Gig.paRental)
                HStack {
                    TextField("0", value: $paLeie, formatter: numberFormatter)
                        .focused($focusedField, equals: .paLeie)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("kr")
                }
            }
        }
    }
    
    private var kjøringSection: some View {
        Section(header: Text(Strings.Gig.driving)) {
            if kjøring.isEmpty {
                Text(Strings.Gig.noDriving)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(kjøring.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(kjøring[index].medlem.navn)
                                .font(.headline)
                            Text("\(kjøring[index].kilometer) km")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(kjøring[index].beløp, specifier: "%.2f") kr")
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { indexSet in
                    kjøring.remove(atOffsets: indexSet)
                }
            }
            
            Button(action: {
                visLeggTilKjøring = true
            }) {
                Label(Strings.Gig.addDriving, systemImage: "car.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    private var andreUtgifterSection: some View {
        Section(header: Text(Strings.Gig.otherExpenses)) {
            if andreUtgifter.isEmpty {
                Text(Strings.Gig.noExpenses)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(andreUtgifter.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(andreUtgifter[index].beskrivelse)
                                .font(.headline)
                            Text(andreUtgifter[index].medlem.navn)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(andreUtgifter[index].beløp, specifier: "%.2f") kr")
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete { indexSet in
                    andreUtgifter.remove(atOffsets: indexSet)
                }
            }
            
            Button(action: {
                visLeggTilUtgift = true
            }) {
                Label(Strings.Gig.addExpense, systemImage: "plus.circle.fill")
                    .foregroundColor(.accentColor)
            }
        }
    }
}
