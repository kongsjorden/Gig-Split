import SwiftUI

struct BandDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var band: Band
    
    @State private var visLeggTilMedlem = false
    @State private var visLeggTilSpillejobb = false
    @AppStorage("defaultKjøregodtgjørelse") private var defaultKjøregodtgjørelse = 3.5
    
    private var medlemmerSection: some View {
        Section {
            if band.medlemmer.isEmpty {
                Text("Ingen medlemmer lagt til")
                    .italic()
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(band.medlemmer.enumerated()), id: \.element.id) { index, medlem in
                    MedlemRow(medlem: $band.medlemmer[index])
                }
                .onDelete { indexSet in
                    band.medlemmer.remove(atOffsets: indexSet)
                }
            }
        } header: {
            Label("MEDLEMMER", systemImage: "person.3.fill")
                .customSectionTitle()
        }
    }
    
    private var spillejobberSection: some View {
        Section {
            if band.spillejobber.isEmpty {
                Text("Ingen spillejobber lagt til")
                    .italic()
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(band.spillejobber.enumerated()), id: \.element.id) { index, spillejobb in
                    NavigationLink {
                        RedigerSpillejobbView(spillejobb: $band.spillejobber[index], band: band)
                    } label: {
                        SpillejobbRow(spillejobb: band.spillejobber[index])
                    }
                }
                .onDelete { indexSet in
                    band.spillejobber.remove(atOffsets: indexSet)
                }
            }
        } header: {
            Label("SPILLEJOBBER", systemImage: "music.note.list")
                .customSectionTitle()
        }
    }
    
    var body: some View {
        List {
            medlemmerSection
            spillejobberSection
        }
        .navigationTitle(band.navn)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        visLeggTilMedlem = true
                    } label: {
                        Label("Legg til medlem", systemImage: "person.badge.plus")
                    }
                    
                    Button {
                        visLeggTilSpillejobb = true
                    } label: {
                        Label("Legg til spillejobb", systemImage: "music.note.list.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $visLeggTilMedlem) {
            NavigationStack {
                NyttMedlemView(
                    defaultKjøregodtgjørelse: defaultKjøregodtgjørelse
                ) { nyttMedlem in
                    band.medlemmer.append(nyttMedlem)
                }
            }
        }
        .sheet(isPresented: $visLeggTilSpillejobb) {
            NavigationStack {
                NySpillejobbView(band: band) { nySpillejobb in
                    band.spillejobber.append(nySpillejobb)
                }
            }
        }
    }
}

struct SpillejobbRow: View {
    let spillejobb: Spillejobb
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(spillejobb.sted)
            Text(spillejobb.dato.formatted(date: .long, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
