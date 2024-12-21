import SwiftUI

struct CustomSectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundStyle(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

extension View {
    func customSectionTitle() -> some View {
        modifier(CustomSectionTitleModifier())
    }
}
