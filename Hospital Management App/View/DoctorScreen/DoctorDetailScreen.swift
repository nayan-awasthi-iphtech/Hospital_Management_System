import SwiftUI
internal import CoreData

struct DoctorDetailScreen: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var isPresented: Bool = false
    
    @ObservedObject var doctor: Doctor
    @ObservedObject var user: User
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            ZStack {
                Color(red: 0.96, green: 0.95, blue: 0.93)
                    .ignoresSafeArea()
                
                RadialGradient(
                    colors: [
                        Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.40),
                        Color.clear
                    ],
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 400
                )
                .ignoresSafeArea()
                
                RadialGradient(
                    colors: [
                        Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.30),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 50,
                    endRadius: 500
                )
                .ignoresSafeArea()
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            if let binaryData = doctor.imageData, let uiImage = UIImage(data: binaryData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.blue.opacity(0.8))
                                    .background(Circle().fill(Color(.systemBackground)))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            }
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 22, height: 22)
                                .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 3))
                                .padding(.trailing, 4)
                                .padding(.bottom, 4)
                        }
                        
                        VStack(spacing: 6) {
                            Text(doctor.name ?? "Unknown Doctor")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(doctor.department?.uppercased() ?? "GENERAL MEDICINE")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    
                    // MARK: - Experience & Qualification Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Qualifications & Experience")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(alignment: .top, spacing: 0) {
                            // Experience Column
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Experience")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                Text("\(doctor.experienceYears) yrs")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider()
                                .frame(height: 36)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Qualification")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                
                                Text(doctor.qualification ?? "N/A")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About Doctor")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(doctor.about ?? "Not very much good doctor")")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        isPresented = true
                    }) {
                        Text("Book Appointment")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 20)
                }
                .padding(.top, 16)
            }
        }
        .navigationDestination(isPresented: $isPresented) {
            Appointment_Booking(doctor: doctor, selectedTab: $selectedTab, currentUser: user)
        }
    }
}

