import SwiftUI
internal import CoreData

struct UserProfileView: View {
    
    @State private var isShowEditSheet: Bool = false
    @EnvironmentObject var viewModel: UserViewModel
    
    @State private var showLogoutAlet: Bool = false
    
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
                        
                        Button(action: {
                            showLogoutAlet = true
                        }) {
                            HStack(spacing:6){
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Logout")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.12))
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
                .alert("Logout", isPresented: $showLogoutAlet){
                    Button("Logout", role: .destructive) {
                        viewModel.logout()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to log out of your account")
                }
            } else {
                ContentUnavailableView("No User Profile Found", systemImage: "person.crop.circle.badge.exclamationmark")
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}
