import SwiftUI

struct NavigationCard: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.white)

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
    }
}