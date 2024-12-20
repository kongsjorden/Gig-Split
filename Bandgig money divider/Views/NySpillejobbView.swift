import SwiftUI

struct NySpillejobbView: View {
    @Environment(\.dismiss) var dismiss
    let band: Band
    let onSave: (Spillejobb) -> Void
    
    @State private var sted = ""
    @State private var dato = Date()
    @State private var bruttoInntekt: Double = 0
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
        return formatter
    }()
    
    var body: some View {
        Form {
            basicInfoSection
            economySection
            kjøringSection
            andreUtgifterSection
        }
        .navigationTitle(Strings.Gig.newGig)
        .navigationBarItems(
            leading: Button(Strings.Common.cancel) {
                dismiss()
            },
            trailing: Button(Strings.Common.save) {
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
        )
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
        .toolbar {
            if focusedField != nil {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(Strings.Common.done) {
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
            HStack {
                Text(Strings.Gig.grossIncome)
                Spacer()
                TextField("0", value: $bruttoInntekt, formatter: numberFormatter)
                    .focused($focusedField, equals: .bruttoInntekt)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                Text("kr")
            }
            
            HStack {
                Text(Strings.Gig.paRental)
                Spacer()
                TextField("0", value: $paLeie, formatter: numberFormatter)
                    .focused($focusedField, equals: .paLeie)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                Text("kr")
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
    
    private var andreUtgifterSection: some View {
        Section(header: Text(Strings.Gig.otherExpenses)) {
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
}