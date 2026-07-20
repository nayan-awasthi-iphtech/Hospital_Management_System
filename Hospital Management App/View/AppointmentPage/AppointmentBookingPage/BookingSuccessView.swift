//
//  BookingSuccessView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import SwiftUI

struct BookingSuccessView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var doctor: Doctor
    let selectedDate: Date
    let selectedTimeSlot: String
    let isAnimated: Bool
    var navTap:()->Void
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimated)
            
            Text("Booking Confirmed!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Your appointment with \(doctor.name ?? "the specialist") has been successfully scheduled.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(spacing: 8) {
                Text("📅 \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                Text("⏰ \(selectedTimeSlot)")
            }
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(12)
            
            Spacer()
            
           
            Button(action: {
                navTap()
                dismiss()
            }) {
                Text("Go Back to Bookings Page")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .transition(.opacity.combined(with: .scale))
    }
}
