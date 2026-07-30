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
    @StateObject private var viewModel = AppointmentViewModel()
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
            
            if viewModel.isBookingSuccess   {
                BookingSuccessView(
                    doctor: doctor,
                    selectedDate: viewModel.selectedDate,
                    selectedTimeSlot: viewModel.selectedTimeSlot,
                    isAnimated: viewModel.isBookingSuccess,
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
                                
                                DatePicker("Choose Date", selection: $viewModel.selectedDate, in: Date()..., displayedComponents: .date)
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
                                            .foregroundColor(viewModel.selectedTimeSlot == slot ? .white : .primary)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 45)
                                            .background(viewModel.selectedTimeSlot == slot ? Color.blue : Color(.systemBackground))
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.01), radius: 3)
                                            .onTapGesture {
                                                viewModel.selectedTimeSlot = slot
                                            }
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    
                    Button(action:{
                        viewModel.bookAppointment(doctor: doctor, currentUser: currentUser)
                    }) {
                        Text("Confirm Appointment")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(viewModel.selectedTimeSlot.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(16)
                            .shadow(color: viewModel.selectedTimeSlot.isEmpty ? Color.clear : Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(viewModel.selectedTimeSlot.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle(viewModel.isBookingSuccess ? "" : "Book Appointment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

