import SwiftUI

struct NySpillejobbView: View {
    @Environment(\.dismiss) var dismiss
    let band: Band
    let onSave: (Spillejobb) -> Void
    
    @State private var sted = ""
    @State private var dato = Date()
    @State private var bruttoInntektText = ""
    @State private var bruttoInntekt: Double = 0
    @State private var paLeieText = ""
    @State private var paLeie: Double = 0
    @State private var kjøring: [KjøringDetalj] = []
    @State private var andreUtgifter: [Utgift] = []
    @State private var visLeggTilKjøring = false
    @State private var visLeggTilUtgift = false
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case sted, bruttoInntekt, paLeie
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
    
    private var grunnleggendeInformasjonSection: some View {
        Section {
            TextField(Strings.Gig.venue, text: $sted)
                .focused($focusedField, equals: .sted)
            DatePicker(Strings.Gig.date, selection: $dato, displayedComponents: [.date])
        } header: {
            Text("GRUNNLEGGENDE INFORMASJON")
                .customSectionTitle()
        }
    }
    
    private var økonomiSection: some View {
        Section {
            HStack {
                Text(Strings.Gig.grossIncome)
                Spacer()
                TextField("0", text: $bruttoInntektText)
                    .focused($focusedField, equals: .bruttoInntekt)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    .onChange(of: bruttoInntektText) { oldValue, newValue in
                        let number = parseNumber(newValue)
                        bruttoInntekt = number
                        bruttoInntektText = formatNumber(number)
                    }
                Text("kr")
            }
            
            HStack {
                Text(Strings.Gig.paRental)
                Spacer()
                TextField("0", text: $paLeieText)
                    .focused($focusedField, equals: .paLeie)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
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
    
    private var kjøringSection: some View {
        Section {
            if kjøring.isEmpty {
                Text(Strings.Gig.noDriving)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(kjøring.indices, id: \.self) { index in
                    kjøringRow(for: kjøring[index])
                }
                .onDelete { indexSet in
                    kjøring.remove(atOffsets: indexSet)
                }
            }
            
            Button(action: {
                visLeggTilKjøring = true
            }) {
                Label(Strings.Gig.addDriving, systemImage: "car")
            }
        } header: {
            Text("KJØRING")
                .customSectionTitle()
        }
    }
    
    private var andreUtgifterSection: some View {
        Section {
            if andreUtgifter.isEmpty {
                Text(Strings.Gig.noExpenses)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(andreUtgifter.indices, id: \.self) { index in
                    utgiftRow(for: andreUtgifter[index])
                }
                .onDelete { indexSet in
                    andreUtgifter.remove(atOffsets: indexSet)
                }
            }
            
            Button(action: {
                visLeggTilUtgift = true
            }) {
                Label(Strings.Gig.addExpense, systemImage: "plus.circle")
            }
        } header: {
            Text("ANDRE UTGIFTER")
                .customSectionTitle()
        }
    }
    
    private func kjøringRow(for kjøring: KjøringDetalj) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(kjøring.medlem.navn)
                    .font(.headline)
                Text("\(kjøring.kilometer) km")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(kjøring.beløp, specifier: "%.2f") kr")
                .foregroundStyle(.secondary)
        }
    }
    
    private func utgiftRow(for utgift: Utgift) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(utgift.beskrivelse)
                    .font(.headline)
                Text(utgift.medlem.navn)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(utgift.beløp, specifier: "%.2f") kr")
                .foregroundStyle(.secondary)
        }
    }
    
    var body: some View {
        Form {
            grunnleggendeInformasjonSection
            økonomiSection
            kjøringSection
            andreUtgifterSection
        }
        .customNavigationTitle("Ny spillejobb")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(Strings.Common.cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(Strings.Common.save) {
                    let spillejobb = Spillejobb(
                        sted: sted,
                        dato: dato,
                        bruttoInntekt: bruttoInntekt,
                        paLeie: paLeie,
                        kjøring: kjøring,
                        andreUtgifter: andreUtgifter
                    )
                    onSave(spillejobb)
                    dismiss()
                }
                .disabled(sted.isEmpty)
            }
        }
        .sheet(isPresented: $visLeggTilKjøring) {
            NavigationStack {
                LeggTilKjøringView(
                    band: band,
                    onSave: { nyKjøring in
                        kjøring.append(nyKjøring)
                    }
                )
            }
        }
        .sheet(isPresented: $visLeggTilUtgift) {
            NavigationStack {
                LeggTilUtgiftView(
                    band: band,
                    onSave: { nyUtgift in
                        andreUtgifter.append(nyUtgift)
                    }
                )
            }
        }
    }
}