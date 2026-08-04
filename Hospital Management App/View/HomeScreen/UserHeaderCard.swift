//
//  UserHeaderCard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 29/07/26.
//

import SwiftUI
internal import CoreData

struct UserHeaderCard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var themeManager: ThemeManager
    
    @ObservedObject var currentUser: User
    let hasUpcomingAppointment: Bool
    let onNotificationTap: () -> Void
    @Binding var selectedTab: Int
    
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
    
    private var profileImage: Image {
        if let data = currentUser.imageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.fill")
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
            
            Button {
                themeManager.isDarkMode.toggle()
            } label: {
                Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(themeManager.isDarkMode ? Color.goldAmber : Color.accentBrown)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(.white)
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                    )
            }
            
            profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .foregroundColor(.white)
                .clipShape(Circle())
                .onTapGesture {
                    selectedTab = 4
                }
            Button(action: onNotificationTap){
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.accentBrown)
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
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color.headerGradientStart,
                        Color.headerGradientEnd
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
        .shadow(color: Color.headerGradientEnd.opacity(0.25), radius: 18, x: 0, y: 8)
        .padding(.horizontal, 14)
        .padding(.top, 11)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let sampleUser = SessionManager.shared.getActiveUser(in: context) ?? {
        let user = User(context: context)
        user.name = "John Doe"
        user.email = "john@example.com"
        return user
    }()
    
    UserHeaderCard(
        currentUser: sampleUser,
        hasUpcomingAppointment: false,
        onNotificationTap: {},
        selectedTab: .constant(0)
    )
    .environment(\.managedObjectContext, context)
    .environmentObject(ThemeManager.shared)
}
