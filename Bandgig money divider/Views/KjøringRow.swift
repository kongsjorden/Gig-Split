import SwiftUI

struct KjøringRow: View {
    let kjøring: KjøringDetalj
    
    var body: some View {
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
