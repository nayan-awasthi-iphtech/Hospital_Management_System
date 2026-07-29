//
//  DoctorEditScreen.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 28/07/26.
//

import SwiftUI
internal import CoreData

struct DoctorEditScreen: View {
    
    @EnvironmentObject var doctorViewModel: DoctorViewModel
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var doctor: Doctor
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Doctor Details")){
                    HStack(){
                        Text("Name")
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("Enter Doctor Name", text: $doctorViewModel.editname)
                    }
                    HStack(){
                        Text("Experience")
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("Enter Doctor Experience", value: $doctorViewModel.editExperience, format: .number.grouping(.never))
                    }
                    HStack(){
                        Text("Qualification")
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("Enter Doctor Qualifications", text: $doctorViewModel.editQualification)
                    }
                }
                Section(header: Text("About Section")){
                    HStack(){
                        Text("About")
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("Enter doctor information", text: $doctorViewModel.editAbout)
                    }
                }
                
            }
            .onAppear{
                doctorViewModel.updateDoctorFields(for: doctor)
            }
            .navigationTitle("Edit Doctor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        doctorViewModel.cancelEdits()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        doctorViewModel.saveChanges()
                            dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    
    let mockDoctor = try?  PersistenceController.preview.container.viewContext
    
    let doctor = Doctor(context: mockDoctor!)
    DoctorEditScreen(doctor: doctor)
}
