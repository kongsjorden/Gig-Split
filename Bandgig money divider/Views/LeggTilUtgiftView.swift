import SwiftUI
import PhotosUI

struct LeggTilUtgiftView: View {
    @Environment(\.dismiss) var dismiss
    let band: Band
    let onSave: (Utgift) -> Void
    
    @State private var valgtMedlem: Medlem?
    @State private var beskrivelse = ""
    @State private var beløp = ""
    @State private var kvitteringBildeNavn: String?
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case beskrivelse, beløp
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    @State private var visKamera = false
    @State private var visKameraValg = false
    @State private var visKameraIkkeTilgjengeligAlert = false
    @State private var valgtBilde: PhotosPickerItem?
    
    private var kanLagre: Bool {
        valgtMedlem != nil && !beskrivelse.isEmpty && !beløp.isEmpty
    }
    
    var body: some View {
        mainContent
            .customNavigationTitle("Legg til utgift")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Strings.Common.cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Strings.Common.save) {
                        if let medlem = valgtMedlem,
                           let utgiftsbeløp = Double(beløp) {
                            let utgift = Utgift(
                                medlem: medlem,
                                beskrivelse: beskrivelse,
                                beløp: utgiftsbeløp,
                                harKvittering: kvitteringBildeNavn != nil
                            )
                            onSave(utgift)
                            dismiss()
                        }
                    }
                    .disabled(!kanLagre)
                }
            }
            .sheet(isPresented: $visKamera) {
                CameraView(bildeNavn: $kvitteringBildeNavn)
            }
            .alert(Strings.Gig.cameraNotAvailable, isPresented: $visKameraIkkeTilgjengeligAlert) {
                Button(Strings.Common.ok, role: .cancel) { }
            }
            .onChange(of: valgtBilde) { _, newValue in
                handleValgtBildeEndring()
            }
    }
    
    private var mainContent: some View {
        Form {
            medlemSection
            if valgtMedlem != nil {
                utgiftSection
                kvitteringSection
            }
        }
    }
    
    private var medlemSection: some View {
        Section(header: Text(Strings.Gig.selectMember)) {
            if band.medlemmer.isEmpty {
                Text(Strings.Band.noMembers)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                Picker(Strings.Gig.selectMember, selection: $valgtMedlem) {
                    Text(Strings.Gig.selectMember)
                        .tag(nil as Medlem?)
                    ForEach(band.medlemmer) { medlem in
                        Text(medlem.navn)
                            .tag(medlem as Medlem?)
                    }
                }
            }
        }
    }
    
    private var utgiftSection: some View {
        Section {
            TextField(Strings.Gig.description, text: $beskrivelse)
                .focused($focusedField, equals: .beskrivelse)
            
            HStack {
                TextField(Strings.Gig.amount, text: $beløp)
                    .focused($focusedField, equals: .beløp)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                Text("kr")
            }
        }
    }
    
    private var kvitteringSection: some View {
        Section(header: Text(Strings.Gig.receiptOptional)) {
            HStack {
                if let kvitteringBildeNavn = kvitteringBildeNavn {
                    kvitteringBilde(for: kvitteringBildeNavn)
                }
                
                Spacer()
                
                kameraKnapp
                bildeVelgerKnapp
            }
            .confirmationDialog(Strings.Gig.chooseSource, isPresented: $visKameraValg) {
                Button(Strings.Gig.takePhoto) {
                    visKamera = true
                }
                PhotosPicker(selection: $valgtBilde,
                            matching: .images) {
                    Text(Strings.Gig.chooseFromLibrary)
                }
            }
        }
    }
    
    private func kvitteringBilde(for bildeNavn: String) -> some View {
        let bildePath = getDocumentsDirectory().appendingPathComponent(bildeNavn)
        if let uiImage = UIImage(contentsOfFile: bildePath.path()) {
            return Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
        return Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
    }
    
    private var kameraKnapp: some View {
        Button(action: {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                visKameraValg = true
            } else {
                visKameraIkkeTilgjengeligAlert = true
            }
        }) {
            Image(systemName: "camera.fill")
                .foregroundColor(.blue)
        }
    }
    
    private var bildeVelgerKnapp: some View {
        PhotosPicker(selection: $valgtBilde,
                    matching: .images) {
            Image(systemName: "photo.fill")
                .foregroundColor(.blue)
        }
    }
    
    private func handleValgtBildeEndring() {
        Task {
            if let valgtBilde = valgtBilde,
               let data = try? await valgtBilde.loadTransferable(type: Data.self) {
                let bildeNavn = UUID().uuidString + ".jpg"
                let url = getDocumentsDirectory().appendingPathComponent(bildeNavn)
                try? data.write(to: url)
                await MainActor.run {
                    self.kvitteringBildeNavn = bildeNavn
                }
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var bildeNavn: String?
    
    init(bildeNavn: Binding<String?>) {
        _bildeNavn = bildeNavn
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let bilde = info[.originalImage] as? UIImage,
               let data = bilde.jpegData(compressionQuality: 0.8) {
                let bildeNavn = UUID().uuidString + ".jpg"
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent(bildeNavn)
                try? data.write(to: url)
                parent.bildeNavn = bildeNavn
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}