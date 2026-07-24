import SwiftUI
internal import CoreData

struct HomeScreen: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Binding var selectedTab: Int
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Appointment.date, ascending: true)],
        animation: .default
    ) private var appointments: FetchedResults<Appointment>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.name, ascending: true)],
        animation: .default
    ) private var medicines: FetchedResults<Medicine>

    private var currentUser: User? {
        PersistenceController.shared.currentUser
    }
    
    private var upcomingUserAppointment: [Appointment] {
        let now = Date()
        return appointments.filter{ appointment in
            let isFutureorToday = (appointment.date ?? .distantPast) >= Calendar.current.startOfDay(for: now)
            let isNotCancelled = appointment.status?.lowercased() != "canceled" && appointment.status?.lowercased() != "completed"
            
            return isFutureorToday && isNotCancelled
        }
    }
    
    var body: some View {
        let userAppointments = appointments.filter { $0.appointment_user == currentUser }
        let userMedicines = medicines.filter { $0.medicine_user == currentUser }
        
        NavigationStack {
            ZStack {
                ZStack {
                    Color(red: 0.96, green: 0.95, blue: 0.93)
                        .ignoresSafeArea()
                    
                    RadialGradient(
                        colors: [
                            Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.45),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 400
                    )
                    .ignoresSafeArea()
                    
                    RadialGradient(
                        colors: [
                            Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 500
                    )
                    .ignoresSafeArea()
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Good Morning,")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white.opacity(0.9))
                                
                                Text(currentUser?.name ?? "User")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                            
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.45, green: 0.32, blue: 0.22))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(.white)
                                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                                    )
                                
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2)
                                    )
                                    .offset(x: -1, y: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 22)
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.72, green: 0.58, blue: 0.46),
                                        Color(red: 0.55, green: 0.41, blue: 0.30)
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
                        .shadow(color: Color(red: 0.55, green: 0.41, blue: 0.30).opacity(0.25), radius: 18, x: 0, y: 8)
                        .padding(.horizontal, 14)
                        .padding(.top, 11)
                        
                        HealthInfoCard()
                        
                        MetricCountersRow(
                            appointmentCount: userAppointments.count,
                            prescriptionCount: userMedicines.count,
                            reportCount: currentUser?.user_report?.count ?? 0
                        )
                        
                        UpcomingAppointmentCard(appointment: upcomingUserAppointment.first, selectedTab: $selectedTab)
                        
                        PendingMedicinesSection()
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
