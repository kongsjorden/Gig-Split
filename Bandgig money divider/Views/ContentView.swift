import SwiftUI
import Observation

@Observable
class BandStore {
    var bands: [Band] = []
    var visLeggTilBand = false
    
    private let bandsKey = "savedBands"
    
    func lagreBands() {
        if let encodedData = try? JSONEncoder().encode(bands) {
            UserDefaults.standard.set(encodedData, forKey: bandsKey)
            print("Lagret \(bands.count) band")
            for band in bands {
                print("- \(band.navn): \(band.medlemmer.count) medlemmer")
            }
        }
    }
    
    func lastBands() {
        if let savedData = UserDefaults.standard.data(forKey: bandsKey),
           let decodedBands = try? JSONDecoder().decode([Band].self, from: savedData) {
            bands = decodedBands
            print("Lastet \(bands.count) band")
            for band in bands {
                print("- \(band.navn): \(band.medlemmer.count) medlemmer")
            }
        }
    }
}

struct ContentView: View {
    @State private var bandStore = BandStore()
    
    var body: some View {
        NavigationStack {
            List {
                if bandStore.bands.isEmpty {
                    Text(Strings.Band.noBands)
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(bandStore.bands) { band in
                        NavigationLink(value: band) {
                            Text(band.navn)
                        }
                    }
                    .onDelete { indexSet in
                        bandStore.bands.remove(atOffsets: indexSet)
                        bandStore.lagreBands()
                    }
                }
            }
            .navigationTitle(Strings.Band.bands)
            .navigationDestination(for: Band.self) { band in
                if let index = bandStore.bands.firstIndex(where: { $0.id == band.id }) {
                    BandDetailView(band: bandStore.bands[index])
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        bandStore.visLeggTilBand = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $bandStore.visLeggTilBand) {
                NavigationStack {
                    LeggTilBandView { nyttBand in
                        bandStore.bands.append(nyttBand)
                        bandStore.lagreBands()
                    }
                }
            }
        }
        .onAppear {
            bandStore.lastBands()
        }
    }
}