//
//  DoctorBookingHeaderView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import SwiftUI
internal import CoreData

struct DoctorBookingHeaderView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var doctor: Doctor
    
    var body: some View {
        HStack(spacing: 16) {
            if let data = doctor.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name ?? "Doctor Profile")
                    .font(.headline)
                Text(doctor.department ?? "Specialist")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    let mockData = try? PersistenceController.preview.container.viewContext.fetch(Doctor.fetchRequest()).first
    DoctorBookingHeaderView(doctor: mockData!)
}
