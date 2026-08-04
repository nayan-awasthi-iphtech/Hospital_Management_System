import SwiftUI
internal import CoreData

struct DoctorDetailScreen: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var doctorViewModel: DoctorViewModel
    @StateObject var authViewModel = AuthViewModel()
    @State private var isPresented: Bool = false
    @State private var isShowEditSheet: Bool = false
    
    @ObservedObject var doctor: Doctor
    @ObservedObject var user: User
    @Binding var selectedTab: Int
    @State private var UserCompleteProfileAlert: Bool = false
    @State private var showCompleteProfileSheet: Bool = false
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            VStack{
                HStack(alignment: .center, spacing: 10) {
                    Text("Profile")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color.primaryText)
                        .tracking(0.5)
                    
                    Spacer()
                    
                    Button(action: {
                        doctorViewModel.updateDoctorFields(for: doctor)
                        isShowEditSheet = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .bold))
                            Text("Edit")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        VStack(spacing: 10) {
                            ZStack(alignment: .bottomTrailing) {
                                if let binaryData = doctor.imageData, let uiImage = UIImage(data: binaryData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.blue.opacity(0.8))
                                        .background(Circle().fill(Color.cardBackground))
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                }
                                
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 22, height: 22)
                                    .overlay(Circle().stroke(Color.cardBackground, lineWidth: 3))
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
                        .background(Color.cardBackground)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Qualifications & Experience")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack(alignment: .top, spacing: 0) {
                                
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
                        .background(Color.cardBackground)
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
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            if authViewModel.isAnyDetailMissing(for: user){
                                UserCompleteProfileAlert = true
                            } else {
                                isPresented = true
                            }
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
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .navigationDestination(isPresented: $isPresented) {
            Appointment_Booking(doctor: doctor, selectedTab: $selectedTab, currentUser: user)
        }
        .alert("Complete Your Profile",isPresented: $UserCompleteProfileAlert){
            Button("Update Now") {
                showCompleteProfileSheet = true
            }
            Button("Later", role: .cancel) { }
        }  message: {
            Text("Complete your profile first, So Doctor can give you better treatment")
        }
        .sheet(isPresented: $showCompleteProfileSheet){
            UserCompleteProfileView()
        }
        .sheet(isPresented: $isShowEditSheet){
            DoctorEditScreen(doctor: doctor)
                .environmentObject(doctorViewModel)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let doctorData: NSFetchRequest<Doctor> = Doctor.fetchRequest()
    let doctor = (try? context.fetch(doctorData).first) ?? Doctor(context: context)
    
    let userData: NSFetchRequest<User> = User.fetchRequest()
    let user = (try? context.fetch(userData).first) ?? User(context: context)
    
    DoctorDetailScreen(
        doctor: doctor,
        user: user,
        selectedTab: .constant(0)
    )
    .environment(\.managedObjectContext, context)
}
