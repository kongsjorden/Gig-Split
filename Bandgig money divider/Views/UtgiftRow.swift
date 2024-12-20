import SwiftUI

struct UtgiftRow: View {
    let utgift: Utgift
    
    var body: some View {
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
