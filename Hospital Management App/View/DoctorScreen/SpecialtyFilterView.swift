//
//  SpecialtyFilterView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

//import SwiftUI
//
//struct SpecialtyFilterView: View {
//    @Binding var selectedCategory: String
//    let categories: [String]
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(categories, id: \.self) { category in
//                    CategoryBadge(
//                        title: category,
//                        isSelected: selectedCategory == category,
//                        action: {
//                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                                selectedCategory = category
//                            }
//                        }
//                    )
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 8)
//        }
//    }
//}
//
//struct CategoryBadge: View {
//    let title: String
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(.subheadline)
//                .fontWeight(.semibold)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 10)
//                .background(isSelected ? Color.blue : Color(.systemBackground))
//                .foregroundColor(isSelected ? .white : .primary)
//                .cornerRadius(20)
//                .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.03), radius: 4, x: 0, y: 2)
//        }
//    }
//}
//
//#Preview {
//    SpecialtyFilterView(selectedCategory: .constant("All"), categories: ["All", "Cardiologist"])
//}


//
//  SpecialtyFilterView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

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
    
    // MARK: - Premium Color Palette
    private let activeBackground = Color(red: 0.30, green: 0.22, blue: 0.16) // Deep Warm Espresso
    private let activeText = Color(red: 0.98, green: 0.96, blue: 0.93)       // Soft Cream
    
    private let inactiveBackground = Color.white.opacity(0.70)             // Semi-translucent Soft White
    private let inactiveText = Color(red: 0.40, green: 0.33, blue: 0.27)     // Warm Muted Brown
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

#Preview {
    ZStack {
        Color(red: 0.96, green: 0.95, blue: 0.93)
            .ignoresSafeArea()
        SpecialtyFilterView(
            selectedCategory: .constant("All"),
            categories: ["All", "Cardiology", "Neurology", "Pediatrics"]
        )
    }
}
