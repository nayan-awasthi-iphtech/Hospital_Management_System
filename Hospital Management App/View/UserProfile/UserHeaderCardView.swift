//
//  UserHeaderCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct UserHeaderCardView: View {
    
    @ObservedObject var user: User
    
    @State private var showExpandedQR = false
    
    private var userName: String {
        user.name ?? "Unknown"
    }
    
    private var patientIDText: String {
        let idString = user.id?.uuidString.prefix(8) ?? "N/A"
        return "Patient ID: \(idString)"
    }
    
    private var profileImage: Image {
        if let data = user.imageData, let uiImage = UIImage(data: data){
            return Image(uiImage: uiImage)
        }
        else {
            return Image("user1")
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 56, height: 56)
                    
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text(patientIDText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: { showExpandedQR = true }) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.blue)
                        .padding(10)
                        .background(Color.blue.opacity(0.08), in: Circle())
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.white).opacity(0.8))
                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
                .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showExpandedQR) {
            ExpandedQRModalView(
                isPresented: $showExpandedQR,
                patientName: user.name ?? "Unknown Patient",
                patientID: patientIDText
            )
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let sampleUser = User(context: context)
    sampleUser.id = UUID()
    sampleUser.name = "Alex Johnson"
    sampleUser.bloodGroup = "O+"
    sampleUser.dob = Calendar.current.date(byAdding: .year, value: -32, to: Date())
    
    return UserHeaderCardView(user: sampleUser)
        .environment(\.managedObjectContext, context)
}
