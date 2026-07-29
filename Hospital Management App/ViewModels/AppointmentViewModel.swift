//
//  AppointmentViewModel.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 29/07/26.
//

import Foundation
internal import CoreData
internal import Combine
import SwiftUI

class AppointmentViewModel: ObservableObject {
    
    @Published var appointments: [Appointment] = []
    
    // Booking state data
    @Published var selectedDate = Date()
    @Published var selectedTimeSlot: String = ""
    @Published var isBookingSuccess: Bool = false
    @Published var errorMessage: String?
    
    // Booking History data
    
    @Published var appointemntToReschedule: Appointment? = nil
    @Published var showConfirmDeleteAppt: Bool = false
    @Published var ApptToDelete: [Appointment] = []
    
    var currentUser: User? {
        return PersistenceController.shared.currentUser
    }
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext){
        self.context = context
    }
    
    var UpcomingAppointment:[Appointment]{
        guard let user = currentUser else { return []}
        return appointments.filter{ app in
            guard app.appointment_user == user else { return false }
            let status = app.status ?? ""
            return status.localizedCaseInsensitiveContains("Scheduled") || status.isEmpty
        }
    }
    
    var passedAppointment: [Appointment] {
        guard let user = currentUser else { return []}
        return appointments.filter{ app in
            guard app.appointment_user == user else { return false }
            let status = app.status ?? ""
            return status.localizedCaseInsensitiveContains("Completed") || status.localizedCaseInsensitiveContains("Cancelled") || status.localizedCaseInsensitiveContains("Canceled")
        }
    }
    
    func fetchAppointments(){
        let request: NSFetchRequest<Appointment> = Appointment.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Appointment.date, ascending: true)]
        
        do {
            self.appointments = try context.fetch(request)
        } catch {
            self.errorMessage = "Failed to fetch the appointments: \(error.localizedDescription)"
            print("error in fetching appointments: \(error.localizedDescription)")
        }
    }
    
    func bookAppointment(doctor: Doctor, currentUser: User){
        let appointmentID = UUID()
        let appointment = Appointment(context: context)
        appointment.id = appointmentID
        appointment.date = selectedDate
        appointment.timeSlot = selectedTimeSlot
        appointment.status = "Scheduled"
        appointment.appointment_doctor = doctor
        appointment.appointment_user = currentUser
        
        do {
            try context.save()
            print("Appointment Booked Successfuly")
            
            if let exactAppointmentDate = combine(date: selectedDate, timeSlotString: selectedTimeSlot){
                NotificationManager.shared.ScheduleNotification(id: appointmentID.uuidString, title: "Upcoming Appointment 📅", body: "Reminder: You have an appointment booked with \(doctor.name ?? "your doctor") soon.", targetDate: exactAppointmentDate)
                
                NotificationManager.shared.sendInstantNotification(id: appointmentID.uuidString, title: "Upcoming Appointment 📅", body: "Reminder: You have an appointment booked with \(doctor.name ?? "your doctor") soon.")
            }
            
            fetchAppointments()
            withAnimation(.easeInOut(duration: 0.4)){
                self.isBookingSuccess = true
            }
        } catch {
            self.errorMessage = "Failed to book appointment: \(error.localizedDescription)"
            print("Error in booking appointment: (\(error.localizedDescription)")
        }
    }
    
    func cancelAppointment(_ appointment: Appointment){
        appointment.status = "Cancelled"
        saveContext()
    }
    func prepareForDelete(at offsets: IndexSet, from list: [Appointment]){
        self.ApptToDelete = offsets.map { list[$0] }
        showConfirmDeleteAppt = true
    }
    
    func deleteSelectedAppoitments(){
        ApptToDelete.forEach(context.delete)
        saveContext()
        ApptToDelete.removeAll()
    }
    
    private func saveContext() {
        do {
            try context.save()
            fetchAppointments()
        } catch {
            self.errorMessage = "Failed to update database. Please, try again."
            print("Error saving context: \(error.localizedDescription)")
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
