//
//  EmergencyContactCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
internal import CoreData

struct EmergencyContactCardView: View {
    
    let user: User
    var body: some View {
        VStack(alignment:.leading, spacing:14){
            Text("Emergency Contact")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack(spacing:14){
                ZStack(){
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "phone.fill")
                        .foregroundStyle(Color.red)
                        .font(.system(size:18))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("John Rodriguez")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text("Husband • \(user.phone ?? "9999999999")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    if let url = URL(string: "tel://\(user.phone ?? "")") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "phone.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.blue.opacity(0.5))
                }
            }
        }
        .padding(18)
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    EmergencyContactCardView(user: sampleUser)
}
