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
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.blue : Color(.systemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.03), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    SpecialtyFilterView(selectedCategory: .constant("All"), categories: ["All", "Cardiologist"])
}
