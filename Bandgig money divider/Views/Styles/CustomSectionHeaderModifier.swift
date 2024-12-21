import SwiftUI

struct CustomSectionHeaderModifier: ViewModifier {
    let title: String
    let systemImage: String
    
    func body(content: Content) -> some View {
        Section {
            content
        } header: {
            Label(title, systemImage: systemImage)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
}

extension View {
    func customSectionHeader(title: String, systemImage: String) -> some View {
        modifier(CustomSectionHeaderModifier(title: title, systemImage: systemImage))
    }
}
