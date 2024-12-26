import SwiftUI

struct RedigerSpillejobbView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var spillejobb: Spillejobb
    let band: Band
    
    @State private var sted: String
    @State private var dato: Date
    @State private var bruttoInntektText: String
    @State private var bruttoInntekt: Double
    @State private var paLeieText: String
    @State private var paLeie: Double
    @State private var kjøring: [KjøringDetalj]
    @State private var andreUtgifter: [Utgift]
    @State private var visLeggTilKjøring = false
    @State private var visLeggTilUtgift = false
    @State private var visFordelOverskudd = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case sted, bruttoInntekt, paLeie
    }
    
    init(spillejobb: Binding<Spillejobb>, band: Band) {
        self._spillejobb = spillejobb
        self.band = band
        self._sted = State(initialValue: spillejobb.wrappedValue.sted)
        self._dato = State(initialValue: spillejobb.wrappedValue.dato)
        self._bruttoInntektText = State(initialValue: String(format: "%.0f", spillejobb.wrappedValue.bruttoInntekt))
        self._bruttoInntekt = State(initialValue: spillejobb.wrappedValue.bruttoInntekt)
        self._paLeieText = State(initialValue: String(format: "%.0f", spillejobb.wrappedValue.paLeie))
        self._paLeie = State(initialValue: spillejobb.wrappedValue.paLeie)
        self._kjøring = State(initialValue: spillejobb.wrappedValue.kjøring)
        self._andreUtgifter = State(initialValue: spillejobb.wrappedValue.andreUtgifter)
    }
    
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

    private func parseNumber(_ text: String) -> Double {
        let cleanedText = text.replacingOccurrences(of: " ", with: "")
        return Double(cleanedText) ?? 0
    }
    
    private func lagreEndringer() {
        var oppdatertSpillejobb = spillejobb
        oppdatertSpillejobb.sted = sted
        oppdatertSpillejobb.dato = dato
        oppdatertSpillejobb.bruttoInntekt = bruttoInntekt
        oppdatertSpillejobb.paLeie = paLeie
        oppdatertSpillejobb.kjøring = kjøring
        oppdatertSpillejobb.andreUtgifter = andreUtgifter
        
        // Oppdater spillejobben i binding
        spillejobb = oppdatertSpillejobb
        
        // Oppdater spillejobben i band-objektet
        if let index = band.spillejobber.firstIndex(where: { $0.id == spillejobb.id }) {
            band.spillejobber[index] = oppdatertSpillejobb
        }
        
        dismiss()
    }
    
    var grunnleggendeInformasjonSection: some View {
        Section {
            TextField("Sted", text: $sted)
                .focused($focusedField, equals: .sted)
            DatePicker("Dato", selection: $dato, displayedComponents: [.date])
        } header: {
            Text("GRUNNLEGGENDE INFORMASJON")
                .customSectionTitle()
        }
    }
    
    var økonomiSection: some View {
        Section {
            HStack {
                Text("Bruttoinntekt")
                Spacer()
                TextField("0", text: $bruttoInntektText)
                    .focused($focusedField, equals: .bruttoInntekt)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 120)
                    .onChange(of: bruttoInntektText) { oldValue, newValue in
                        let number = parseNumber(newValue)
                        bruttoInntekt = number
                        bruttoInntektText = formatNumber(number)
                    }
                Text("kr")
            }
            
            HStack {
                Text("PA-leie")
                Spacer()
                TextField("0", text: $paLeieText)
                    .focused($focusedField, equals: .paLeie)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 120)
                    .onChange(of: paLeieText) { oldValue, newValue in
                        let number = parseNumber(newValue)
                        paLeie = number
                        paLeieText = formatNumber(number)
                    }
                Text("kr")
            }
        } header: {
            Text("ØKONOMI")
                .customSectionTitle()
        }
    }
    
    var kjøringSection: some View {
        Section {
            if kjøring.isEmpty {
                Text("Ingen kjøring lagt til")
                    .italic()
                    .foregroundColor(.gray)
            } else {
                ForEach(kjøring.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(kjøring[index].medlem.navn)
                                .font(.headline)
                            Text("\(Int(kjøring[index].kilometer)) km")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(kjøring[index].beløp, specifier: "%.2f") kr")
                            .foregroundColor(.gray)
                    }
                }
                .onDelete { indexSet in
                    kjøring.remove(atOffsets: indexSet)
                }
            }
            
            Button(action: {
                visLeggTilKjøring = true
            }) {
                Label("Legg til kjøring", systemImage: "car.fill")
                    .foregroundColor(.accentColor)
            }
        } header: {
            Text("KJØRING")
                .customSectionTitle()
        }
    }
    
    var andreUtgifterSection: some View {
        Section {
            if andreUtgifter.isEmpty {
                Text("Ingen utgifter registrert")
                    .italic()
                    .foregroundColor(.gray)
            } else {
                ForEach(andreUtgifter.indices, id: \.self) { index in
                    NavigationLink {
                        RedigerUtgiftView(utgift: $andreUtgifter[index], band: band)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(andreUtgifter[index].beskrivelse)
                                    .font(.headline)
                                Text(andreUtgifter[index].medlem.navn)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(andreUtgifter[index].beløp, specifier: "%.2f") kr")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    andreUtgifter.remove(atOffsets: indexSet)
                }
            }
            
            Button(action: {
                visLeggTilUtgift = true
            }) {
                Label("Legg til utgift", systemImage: "plus.circle.fill")
                    .foregroundColor(.accentColor)
            }
        } header: {
            Text("ANDRE UTGIFTER")
                .customSectionTitle()
        }
    }
    
    var fordelingSection: some View {
        Section {
            Button(action: {
                visFordelOverskudd = true
            }) {
                Label("Fordel overskudd", systemImage: "chart.pie.fill")
                    .foregroundColor(.accentColor)
            }
        } header: {
            Text("FORDELING")
                .customSectionTitle()
        }
    }
    
    var body: some View {
        Form {
            grunnleggendeInformasjonSection
            økonomiSection
            kjøringSection
            andreUtgifterSection
            fordelingSection
            
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Totale utgifter")
                        Spacer()
                        Text("\(Int(spillejobb.totaleUtgifter)) kr")
                    }
                    
                    HStack {
                        Text("Overskudd")
                        Spacer()
                        Text("\(Int(spillejobb.overskudd)) kr")
                            .foregroundColor(spillejobb.overskudd >= 0 ? .green : .red)
                    }
                }
            }
        }
        .navigationTitle("Rediger spillejobb")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Lagre") {
                    lagreEndringer()
                }
            }
            
            if focusedField != nil {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Ferdig") {
                        focusedField = nil
                    }
                }
            }
        }
        .sheet(isPresented: $visLeggTilKjøring) {
            NavigationStack {
                LeggTilKjøringView(band: band) { nyKjøring in
                    kjøring.append(nyKjøring)
                }
            }
        }
        .sheet(isPresented: $visLeggTilUtgift) {
            NavigationStack {
                LeggTilUtgiftView(band: band) { nyUtgift in
                    andreUtgifter.append(nyUtgift)
                }
            }
        }
        .sheet(isPresented: $visFordelOverskudd) {
            NavigationStack {
                FordelOverskuddView(
                    spillejobb: spillejobb,
                    band: band
                )
            }
        }
    }
}
