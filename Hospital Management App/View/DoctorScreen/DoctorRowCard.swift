//
//  DoctorViewCard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 16/07/26.
//

import SwiftUI
internal import CoreData

struct DoctorRowCard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    let doctor: Doctor
    
    var body: some View {
        HStack(spacing:16){
            if let binaryData = doctor.imageData, let uiImage = UIImage(data: binaryData){
                Image(uiImage:uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .foregroundStyle(Color.red)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4){
                Text(doctor.name ?? "Dr Unknown")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(doctor.department ?? "General Health")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight:.semibold))
                .foregroundColor(Color(.systemGray3))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 6, x:0, y:3)
        )
    }
}

#Preview {
    let mockDoctor = try? PersistenceController.preview.container.viewContext.fetch(Doctor.fetchRequest()).first
    DoctorRowCard(doctor: mockDoctor!)
}
