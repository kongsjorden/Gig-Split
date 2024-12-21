import SwiftUI

struct FordelOverskuddView: View {
    @Environment(\.dismiss) var dismiss
    let spillejobb: Spillejobb
    let band: Band
    @State private var visDetaljer = false
    
    var body: some View {
        List {
            // Bruttoinntekt
            HStack {
                Text("Bruttoinntekt")
                Spacer()
                Text("\(Int(spillejobb.bruttoInntekt)) kr")
            }
            
            // Utgifter
            if visDetaljer {
                Text("Utgifter")
                    .font(.headline)
                    .padding(.top)
                
                HStack {
                    Text("PA-leie")
                    Spacer()
                    Text("\(Int(spillejobb.paLeie)) kr")
                }
                
                if !spillejobb.kjøring.isEmpty {
                    HStack {
                        Text("Kjøring")
                        Spacer()
                        Text("\(Int(spillejobb.kjøringTotalt)) kr")
                    }
                }
                
                if !spillejobb.andreUtgifter.isEmpty {
                    HStack {
                        Text("Andre utgifter")
                        Spacer()
                        Text("\(Int(spillejobb.andreUtgifterTotalt)) kr")
                    }
                }
                
                HStack {
                    Text("Totale utgifter")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(Int(spillejobb.totaleUtgifter)) kr")
                        .fontWeight(.bold)
                }
            }
            
            // Overskudd
            HStack {
                Text("Overskudd")
                    .fontWeight(.bold)
                Spacer()
                Text("\(Int(spillejobb.overskudd)) kr")
                    .fontWeight(.bold)
                    .foregroundColor(spillejobb.overskudd >= 0 ? .green : .red)
            }
            .padding(.top)
            
            // Fordeling
            Text("Fordeling")
                .font(.headline)
                .padding(.top)
            
            let fordeling = spillejobb.fordelOverskudd(mellom: band.medlemmer)
            ForEach(fordeling, id: \.medlem.id) { fordelt in
                HStack {
                    Text(fordelt.medlem.navn)
                    Spacer()
                    Text("\(Int(fordelt.beløp)) kr")
                        .foregroundColor(fordelt.beløp >= 0 ? .green : .red)
                }
            }
        }
        .navigationTitle("Fordeling av overskudd")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    visDetaljer.toggle()
                }) {
                    Text(visDetaljer ? "Skjul detaljer" : "Vis detaljer")
                }
            }
        }
    }
}
