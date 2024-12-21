import SwiftUI
import Observation

@Observable
class BandStore {
    var bands: [Band] = []
    var showingAddBand = false
    
    private let bandsKey = "savedBands"
    
    init() {
        loadBands()
    }
    
    func loadBands() {
        if let data = UserDefaults.standard.data(forKey: bandsKey),
           let decodedBands = try? JSONDecoder().decode([Band].self, from: data) {
            self.bands = decodedBands
        }
    }
    
    func saveBands() {
        if let encoded = try? JSONEncoder().encode(bands) {
            UserDefaults.standard.set(encoded, forKey: bandsKey)
        }
    }
    
    func deleteBand(at offsets: IndexSet) {
        bands.remove(atOffsets: offsets)
        saveBands()
    }
}

struct ContentView: View {
    @State private var bandStore = BandStore()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bandStore.bands) { band in
                    NavigationLink(destination: BandDetailView(band: band)) {
                        Text(band.navn)
                            .font(.title3)
                            .foregroundColor(.purple)
                            .padding(.vertical, 5)
                    }
                }
                .onDelete(perform: bandStore.deleteBand)
            }
            .customNavigationTitle("Band")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        bandStore.showingAddBand = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 25))
                            .foregroundStyle(.blue)
                            .padding(5)
                    }
                }
            }
            .overlay(Group {
                if bandStore.bands.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 50))
                            .foregroundColor(.purple)
                        Text("Ingen band ennå")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Trykk + for å legge til ditt første band")
                            .foregroundColor(.gray)
                    }
                }
            })
        }
        .sheet(isPresented: $bandStore.showingAddBand) {
            LeggTilBandView { nyttBand in
                bandStore.bands.append(nyttBand)
                bandStore.saveBands()
            }
        }
        .onAppear {
            bandStore.loadBands()
        }
    }
}