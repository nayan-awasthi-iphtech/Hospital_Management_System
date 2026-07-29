//
//  UserHeaderCard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 29/07/26.
//

import SwiftUI

struct UserHeaderCard: View {
    
    let currentUser: User
    let hasUpcomingAppointment: Bool
    let onNotificationTap: () -> Void
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<14:
            return "Good Afternoon"
        case 14..<20:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingMessage)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
                
                Text(currentUser.name ?? "User")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Button(action: onNotificationTap){
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.45, green: 0.32, blue: 0.22))
                        .padding(12)
                        .background(
                            Circle()
                                .fill(.white)
                                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                        )
                    
                    if hasUpcomingAppointment {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                            .offset(x: -1, y: 1)
                    }
                }
            }
            if let uiImage = UIImage(named: "user1"){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.72, green: 0.58, blue: 0.46),
                        Color(red: 0.55, green: 0.41, blue: 0.30)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                RadialGradient(
                    colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.35)
                    ],
                    center: .bottomTrailing,
                    startRadius: 40,
                    endRadius: 220
                )
                
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 6)
        .shadow(color: Color(red: 0.55, green: 0.41, blue: 0.30).opacity(0.25), radius: 18, x: 0, y: 8)
        .padding(.horizontal, 14)
        .padding(.top, 11)
    }
}

