import SwiftUI

struct GradientHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .padding(.vertical, 10)
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2.bold())
            .foregroundStyle(
                LinearGradient(
                    colors: [.indigo.opacity(0.7), .blue.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .padding(.vertical, 5)
    }
}

extension View {
    func gradientHeaderStyle() -> some View {
        modifier(GradientHeaderStyle())
    }
    
    func sectionHeaderStyle() -> some View {
        modifier(SectionHeaderStyle())
    }
}
