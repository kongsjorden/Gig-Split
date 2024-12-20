import SwiftUI

struct LeggTilBandView: View {
    @Environment(\.dismiss) var dismiss
    @State private var bandNavn = ""
    
    var onSave: (Band) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(Strings.Band.name, text: $bandNavn)
                }
            }
            .navigationTitle(Strings.Band.addBand)
            .navigationBarItems(
                leading: Button(Strings.General.cancel) {
                    dismiss()
                },
                trailing: Button(Strings.General.save) {
                    let nyttBand = Band(navn: bandNavn)
                    onSave(nyttBand)
                    dismiss()
                }
                .disabled(bandNavn.isEmpty)
            )
        }
    }
}

#Preview {
    LeggTilBandView { _ in }
}