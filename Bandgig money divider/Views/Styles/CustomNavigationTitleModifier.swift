import SwiftUI

struct CustomNavigationTitleModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .safeAreaInset(edge: .top, spacing: 0) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.clear)
            }
    }
}

extension View {
    func customNavigationTitle(_ title: String) -> some View {
        modifier(CustomNavigationTitleModifier(title: title))
    }
} 