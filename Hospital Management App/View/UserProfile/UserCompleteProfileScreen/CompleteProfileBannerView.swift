//
//  CompleteProfileBannerView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 31/07/26.
//

import SwiftUI

struct CompleteProfileBannerView: View {
    var onAction: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(.system(size: 28))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Incomplete Profile")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Add your emergency contact, blood group, and insurance for better medical care.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            Button(action: onAction) {
                Text("Complete")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                    .clipShape(Capsule())
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }
}
