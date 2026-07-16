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
    
    @State private var selectedDate = Date()
    @State private var selectedTimeSlot: String = ""
    @State private var isBookingSuccess: Bool = false
    
    // Dynamic slots configuration
    let timeSlots = ["09:00 AM", "10:00 AM", "11:30 AM", "02:00 PM", "03:30 PM", "05:00 PM"]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if isBookingSuccess {
       
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                        .scaleEffect(isBookingSuccess ? 1.0 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isBookingSuccess)
                    
                    Text("Booking Confirmed!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Your appointment with \(doctor.name ?? "the specialist") has been successfully scheduled.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Display details to verify runtime binding
                    VStack(spacing: 8) {
                        Text("📅 \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                        Text("⏰ \(selectedTimeSlot)")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss() 
                    }) {
                        Text("Go Back to Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .transition(.opacity.combined(with: .scale))
            } else {
                
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 24) {
                            
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
                                    ForEach(timeSlots, id: \.self) { slot in
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
     
        let appointment = Appointment(context: viewContext)
        appointment.id = UUID()
        appointment.date = selectedDate
        appointment.status = "Scheduled"
        
        appointment.appointment_doctor = doctor
        
        do {
            try viewContext.save()
            
            withAnimation(.easeInOut(duration: 0.4)) {
                isBookingSuccess = true
            }
        } catch {
            print("Fatal Database Write Failure: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let dummyDoctor = Doctor(context: context)
    dummyDoctor.name = "Dr. Alice Green"
    dummyDoctor.department = "Cardiology"
    
    if let uiImage = UIImage(named: "doctor1") {
        dummyDoctor.imageData = uiImage.jpegData(compressionQuality: 0.8)
    }
    
     return NavigationStack {
        Appointment_Booking(doctor: dummyDoctor)
            .environment(\.managedObjectContext, context)
    }
}

