//
//  Appointement_Page.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 15/07/26.
//

import SwiftUI
internal import CoreData

struct Appointment_Booking: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var doctor: Doctor
    
    @Binding var selectedTab:Int
    
    let currentUser: User
    
    @State private var selectedDate = Date()
    @State private var selectedTimeSlot: String = ""
    @State private var isBookingSuccess: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if isBookingSuccess {
                BookingSuccessView(
                    doctor: doctor,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    isAnimated: isBookingSuccess,
                    navTap: {
                        selectedTab = 1
                    }
                )
            } else {
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            DoctorBookingHeaderView(doctor: doctor)
                             
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Select Date")
                                    .font(.headline)
                                
                                DatePicker("Choose Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(16)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Select Available Time")
                                    .font(.headline)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(Appointment.availableTimeSlots, id: \.self) { slot in
                                        Text(slot)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(selectedTimeSlot == slot ? .white : .primary)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 45)
                                            .background(selectedTimeSlot == slot ? Color.blue : Color(.systemBackground))
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.01), radius: 3)
                                            .onTapGesture {
                                                selectedTimeSlot = slot
                                            }
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    
                    Button(action: executeBookingTransaction) {
                        Text("Confirm Appointment")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(selectedTimeSlot.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(16)
                            .shadow(color: selectedTimeSlot.isEmpty ? Color.clear : Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(selectedTimeSlot.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle(isBookingSuccess ? "" : "Book Appointment")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func executeBookingTransaction() {
        let appointmentID = UUID()
        let appointment = Appointment(context: viewContext)
        appointment.id = appointmentID
        appointment.date = selectedDate
        appointment.status = "Scheduled"
        appointment.timeSlot = selectedTimeSlot
        appointment.appointment_doctor = doctor
        appointment.appointment_user = currentUser
        
        do {
            try viewContext.save()

            
            if let bookedUser = appointment.appointment_user {
                    print("✅ Appointment successfully saved!")
                    print("👉 Doctor Name: \(appointment.appointment_doctor?.name ?? "Unknown Doctor")")
                    print("👉 Patient/User Name: \(bookedUser.name ?? "Unknown User")")
                    print("👉 User ID: \(bookedUser.id?.uuidString ?? "No ID")")
                }
            
            if let exactAppointmentDate = combine(date: selectedDate, timeSlotString: selectedTimeSlot){
                NotificationManager.shared.ScheduleNotification(
                    id: appointmentID.uuidString,
                    title: "Upcoming Appointment 📅",
                    body: "Reminder: You have an appointment booked with \(doctor.name ?? "your doctor") soon.",
                    targetDate: exactAppointmentDate,
                    minutesBefore: 0
                )
                NotificationManager.shared.sendInstantNotification(id: appointmentID.uuidString, title: "Upcoming Appointment 📅", body: "Reminder: You have an appointment booked with \(doctor.name ?? "your doctor") soon.")
            }
            
            withAnimation(.easeInOut(duration: 0.4)) {
                isBookingSuccess = true
            }
        } catch {
            print("Fatal Database Write Failure: \(error.localizedDescription)")
        }
    }
    
    private func combine(date: Date, timeSlotString: String) -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a" 
            
            guard let timeDate = formatter.date(from: timeSlotString) else { return nil }
            
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
            
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            
            return calendar.date(from: dateComponents)
        }
}

//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//    
//    let dummyDoctor = Doctor(context: context)
//    dummyDoctor.name = "Dr. Alice Green"
//    dummyDoctor.department = "Cardiology"
//    
//    if let uiImage = UIImage(named: "doctor1") {
//        dummyDoctor.imageData = uiImage.jpegData(compressionQuality: 0.8)
//    }
//    
//    NavigationStack {
//        Appointment_Booking(doctor: dummyDoctor)
//            .environment(\.managedObjectContext, context)
//    }
//}

