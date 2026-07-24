import SwiftUI

struct SpecialtyFilterView: View {
    @Binding var selectedCategory: String
    let categories: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    CategoryBadge(
                        title: category,
                        isSelected: selectedCategory == category,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}

struct CategoryBadge: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private let activeBackground = Color(red: 0.30, green: 0.22, blue: 0.16)
    private let activeText = Color(red: 0.98, green: 0.96, blue: 0.93)
    
    private let inactiveBackground = Color.white.opacity(0.70)
    private let inactiveText = Color(red: 0.40, green: 0.33, blue: 0.27)
    private let borderGold = Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.40)
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(isSelected ? activeBackground : inactiveBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(isSelected ? Color.clear : borderGold, lineWidth: 1)
                )
                .foregroundColor(isSelected ? activeText : inactiveText)
                .shadow(
                    color: isSelected
                        ? Color(red: 0.30, green: 0.22, blue: 0.16).opacity(0.25)
                        : Color.black.opacity(0.03),
                    radius: isSelected ? 6 : 3,
                    x: 0,
                    y: isSelected ? 3 : 1
                )
        }
        .buttonStyle(.plain)
    }
}
