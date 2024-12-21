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
                    .foregroundStyle(.blue)
            }
            
            // Utgifter
            if visDetaljer {
                Text("Utgifter")
                    .font(.headline)
                    .padding(.top)
                
                HStack {
                    Text("PA-leie")
                    Spacer()
                    Text("-\(Int(spillejobb.paLeie)) kr")
                        .foregroundStyle(.red)
                }
                
                if !spillejobb.kjøring.isEmpty {
                    Text("Kjøring")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 5)
                    
                    ForEach(spillejobb.kjøring) { kjøring in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(kjøring.medlem.navn)
                                Text("\(kjøring.kilometer) km")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("-\(Int(kjøring.beløp)) kr")
                                .foregroundStyle(.red)
                        }
                        .padding(.leading)
                    }
                    
                    HStack {
                        Text("Sum kjøring")
                            .fontWeight(.medium)
                        Spacer()
                        Text("-\(Int(spillejobb.kjøringTotalt)) kr")
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                    }
                }
                
                if !spillejobb.andreUtgifter.isEmpty {
                    Text("Andre utgifter")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 5)
                    
                    ForEach(spillejobb.andreUtgifter) { utgift in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(utgift.beskrivelse)
                                Text(utgift.medlem.navn)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("-\(Int(utgift.beløp)) kr")
                                .foregroundStyle(.red)
                        }
                        .padding(.leading)
                    }
                    
                    HStack {
                        Text("Sum andre utgifter")
                            .fontWeight(.medium)
                        Spacer()
                        Text("-\(Int(spillejobb.andreUtgifterTotalt)) kr")
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                    }
                }
                
                HStack {
                    Text("Totale utgifter")
                        .fontWeight(.bold)
                    Spacer()
                    Text("-\(Int(spillejobb.totaleUtgifter)) kr")
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                }
            }
            
            // Overskudd
            HStack {
                Text("Overskudd")
                    .fontWeight(.bold)
                Spacer()
                Text("\(Int(spillejobb.overskudd)) kr")
                    .fontWeight(.bold)
                    .foregroundStyle(spillejobb.overskudd >= 0 ? .green : .red)
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
                        .foregroundStyle(fordelt.beløp >= 0 ? .green : .red)
                }
            }
        }
        .navigationTitle("Fordeling av overskudd")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text(Strings.Common.done)
                }
            }
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
