import SwiftUI

struct MedlemRow: View {
    @Binding var medlem: Medlem
    @State private var visRedigering = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(medlem.navn)
                if medlem.kjøregodtgjørelse > 0 {
                    Text("\(String(format: "%.2f", medlem.kjøregodtgjørelse)) kr/km")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: {
                visRedigering = true
            }) {
                Image(systemName: "pencil.circle")
                    .foregroundStyle(.blue)
            }
        }
        .sheet(isPresented: $visRedigering) {
            NavigationStack {
                RedigerMedlemView(medlem: $medlem)
            }
        }
    }
}
