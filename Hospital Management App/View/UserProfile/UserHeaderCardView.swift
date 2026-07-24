//
//  UserHeaderCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct UserHeaderCardView: View {
    
    let user: User
    
    @State private var showExpandedQR = false
    
    private var userName: String {
        user.name ?? "Unknown"
    }
        
    private var patientIDText: String {
        let idString = user.id?.uuidString.prefix(8) ?? "N/A"
        return "Patient ID: \(idString)"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.blue)
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
            
            Divider()
                .opacity(0.5)
            
            HStack {
                UserStatViewItem(title: "Blood Group", value: user.bloodGroup ?? "A+")
                Spacer()
                UserStatViewItem(title: "Age", value: CalculateAge(from: user.dob))
                Spacer()
                UserStatViewItem(title: "Weight", value: user.weight ?? "99")
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
    
    private func CalculateAge(from date: Date?) -> String {
        guard let dob = date else { return "99 years" }
        let age = Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 0
        return "\(age) years"
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
