import SwiftUI
internal import CoreData

struct UserProfileView: View {
    
    @State private var isShowEditSheet: Bool = false
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        ZStack {
            AppBackgroundView()
        
            if let user = viewModel.currentUser {
                VStack(spacing: 10) {
                    
                    HStack(alignment: .center, spacing: 10) {
                        Text("Profile")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.12))
                            .tracking(0.5)
                        
                        Spacer()
                        
                        Button(action: {
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
                            UserHeaderCardView(user: user)
                            Divider().opacity(0.5)
                            UserInformationCardView(user: user)
                            Divider().opacity(0.5)
                            EmergencyContactCardView(user: user)
                            Divider().opacity(0.5)
                            InsuranceDetailsCardView(user: user)
                            Divider().opacity(0.5)
                            BMICalculatorView(currentUser: user)
                            Divider().opacity(0.5)
                            UserHealthChart(currentUser: user)
                        }
                        .padding(.vertical, 10)
                    }
                    .scrollIndicators(.hidden)
                }
                .sheet(isPresented: $isShowEditSheet) {
                    EditUserProfileSheet()
                        .environmentObject(viewModel)
                }
            } else {
                ContentUnavailableView("No User Profile Found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
    }
}

#Preview {
    let controller = PersistenceController.preview
    let sampleUser = controller.currentUser ?? User(context: controller.container.viewContext)
    
    UserProfileView()
        .environment(\.managedObjectContext, controller.container.viewContext)
        .environmentObject(sampleUser)
}
