import SwiftUI

struct LeggTilBandView: View {
    @Environment(\.dismiss) var dismiss
    @State private var navn = ""
    let onSave: (Band) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Navn", text: $navn)
                        .textInputAutocapitalization(.words)
                }
                .customSectionHeader(title: "BANDINFORMASJON", systemImage: "music.note.list")
            }
            .customNavigationTitle("Legg til band")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Avbryt") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lagre") {
                        let nyttBand = Band(navn: navn)
                        onSave(nyttBand)
                        dismiss()
                    }
                    .disabled(navn.isEmpty)
                }
            }
        }
    }
}

#Preview {
    LeggTilBandView { _ in }
}