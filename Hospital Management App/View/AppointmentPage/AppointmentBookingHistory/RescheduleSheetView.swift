//
//  RescheduleSheetView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 17/07/26.
//

import SwiftUI
internal import CoreData

struct RescheduleSheetView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var appointment: Appointment
    
    var onDismiss: () -> Void
    
    @State private var newDate: Date = Date()
    @State private var newTimePicker:String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:20){
                    VStack(alignment: .leading, spacing: 10){
                        Text("Select New Date")
                            .font(.headline)
                        
                        DatePicker("Choose Date", selection: $newDate, in:Date()..., displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                    }
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Select New Time Slot")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12){
                            ForEach(Appointment.availableTimeSlots, id: \.self){ slot in
                                Text(slot)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(newTimePicker == slot ? .white: .primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(newTimePicker == slot ? Color.blue : Color(.systemGray6))
                                    .cornerRadius(12)
                                    .onTapGesture{
                                        newTimePicker = slot
                                    }
                            }
                        }
                    }
                    
                    Button(action: {saveRescheduledData()}){
                        Text("Update Appointment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(newTimePicker.isEmpty ? Color.gray:  Color.blue)
                            .cornerRadius(14)
                    }
                    .disabled(newTimePicker.isEmpty)
                    .padding(.top, 10)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Reschedule Slot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Close") {
                        onDismiss()
                    }
                }
            }
            .onAppear{
                if let currentDate = appointment.date{
                    newDate = currentDate
                }
                newTimePicker = appointment.safeTimeSlot
            }
        }
    }
    
    private func saveRescheduledData(){
        withAnimation{
            appointment.date = newDate
            appointment.timeSlot = newTimePicker
            appointment.status = "Scheduled"
            
            do{
                try viewContext.save()
                print("Success: Core Data appointment updated successfuly")
                onDismiss()
            } catch {
                print("Error saving appointment: \(error.localizedDescription)")
            }
        }
    }
}

