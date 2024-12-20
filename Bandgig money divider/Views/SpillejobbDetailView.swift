import SwiftUI

struct SpillejobbDetailView: View {
    @Environment(\.dismiss) var dismiss
    let band: Band
    @Binding var spillejobb: Spillejobb
    
    @State private var visLeggTilKjøring = false
    @State private var visLeggTilUtgift = false
    
    var body: some View {
        List {
            Section(header: Text(Strings.Gig.basicInfo)) {
                HStack {
                    Text(Strings.Gig.venue)
                    Spacer()
                    Text(spillejobb.sted)
                }
                HStack {
                    Text(Strings.Gig.date)
                    Spacer()
                    Text(spillejobb.dato.formatted(date: .abbreviated, time: .omitted))
                }
            }
            
            Section(header: Text(Strings.Gig.economy)) {
                HStack {
                    Text(Strings.Gig.grossIncome)
                    Spacer()
                    Text("\(spillejobb.bruttoInntekt, specifier: "%.0f") kr")
                }
                if spillejobb.paLeie > 0 {
                    HStack {
                        Text(Strings.Gig.paRental)
                        Spacer()
                        Text("\(spillejobb.paLeie, specifier: "%.0f") kr")
                    }
                }
            }
            
            Section(header: Text(Strings.Gig.driving)) {
                if spillejobb.kjøring.isEmpty {
                    Text(Strings.Gig.noDriving)
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(spillejobb.kjøring) { kjøring in
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
                }
                
                Button(action: {
                    visLeggTilKjøring = true
                }) {
                    Label(Strings.Gig.addDriving, systemImage: "car")
                }
            }
            
            Section(header: Text(Strings.Gig.otherExpenses)) {
                if spillejobb.andreUtgifter.isEmpty {
                    Text(Strings.Gig.noExpenses)
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(spillejobb.andreUtgifter) { utgift in
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
                
                Button(action: {
                    visLeggTilUtgift = true
                }) {
                    Label(Strings.Gig.addExpense, systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle(spillejobb.sted)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $visLeggTilKjøring) {
            NavigationStack {
                LeggTilKjøringView(band: band) { kjøring in
                    spillejobb.kjøring.append(kjøring)
                }
            }
        }
        .sheet(isPresented: $visLeggTilUtgift) {
            NavigationStack {
                LeggTilUtgiftView(band: band) { utgift in
                    spillejobb.andreUtgifter.append(utgift)
                }
            }
        }
    }
}