import SwiftUI

struct BandDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var band: Band
    
    @State private var visNyttMedlem = false
    @State private var visNySpillejobb = false
    @AppStorage("defaultKjøregodtgjørelse") private var defaultKjøregodtgjørelse = 3.5
    
    var body: some View {
        List {
            Section {
                if band.medlemmer.isEmpty {
                    Text(Strings.Band.noMembers)
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(band.medlemmer) { medlem in
                        MedlemRow(medlem: medlem)
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            band.fjernMedlem(at: index)
                        }
                    }
                }
            } header: {
                HStack {
                    Text(Strings.Band.members)
                    Spacer()
                    Button(action: {
                        visNyttMedlem = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            
            Section {
                if band.spillejobber.isEmpty {
                    Text(Strings.Band.noGigs)
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(band.spillejobber.indices, id: \.self) { index in
                        NavigationLink {
                            RedigerSpillejobbView(spillejobb: $band.spillejobber[index], band: band)
                        } label: {
                            SpillejobbRow(spillejobb: band.spillejobber[index])
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            band.fjernSpillejobb(at: index)
                        }
                    }
                }
            } header: {
                HStack {
                    Text(Strings.Band.gigs)
                    Spacer()
                    Button(action: {
                        visNySpillejobb = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .navigationTitle(band.navn)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $visNyttMedlem) {
            NavigationStack {
                NyttMedlemView(
                    defaultKjøregodtgjørelse: defaultKjøregodtgjørelse
                ) { medlem in
                    print("Legger til medlem: \(medlem.navn)")
                    band.leggTilMedlem(medlem)
                }
            }
        }
        .sheet(isPresented: $visNySpillejobb) {
            NavigationStack {
                NySpillejobbView(
                    band: band
                ) { spillejobb in
                    band.leggTilSpillejobb(spillejobb)
                }
            }
        }
    }
    
    private func binding(for spillejobb: Spillejobb) -> Binding<Spillejobb> {
        Binding(
            get: { spillejobb },
            set: { newValue in
                if let index = band.spillejobber.firstIndex(where: { $0.id == spillejobb.id }) {
                    band.spillejobber[index] = newValue
                }
            }
        )
    }
}

struct MedlemRow: View {
    let medlem: Medlem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(medlem.navn)
                .font(.headline)
            if medlem.kjøregodtgjørelse > 0 {
                Text("\(medlem.kjøregodtgjørelse, specifier: "%.2f") kr/km")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct SpillejobbRow: View {
    let spillejobb: Spillejobb
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(spillejobb.sted)
                .font(.headline)
            HStack {
                Text(spillejobb.dato.formatted(date: .abbreviated, time: .omitted))
                if spillejobb.bruttoInntekt > 0 {
                    Text("•")
                    Text("\(spillejobb.bruttoInntekt, specifier: "%.0f") kr")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}
