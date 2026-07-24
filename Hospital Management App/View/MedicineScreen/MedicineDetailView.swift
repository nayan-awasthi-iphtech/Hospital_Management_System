//
//  MedicineDetailView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 23/07/26.
//

import SwiftUI
internal import CoreData

struct MedicineDetailView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: Medicine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.name, ascending: true)],
        animation: .default
    ) private var medicines: FetchedResults<Medicine>
    
    @State private var refreshToggle: Bool = false
    
    private var totalCount: Int {
        medicines.count
    }
    
    private var takenCount: Int {
        _ = refreshToggle
        return medicines.filter { $0.isTaken }.count
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.93)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                
                Text("Medicines")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.12))
                    .tracking(0.5)
                
                VStack(spacing: 20) {
                    
                    MedicineProgressHeaderView(
                        takenCount: takenCount,
                        totalCount: totalCount
                    )
                    
                    VStack(spacing: 12) {
                        ForEach(medicines, id: \.objectID) { medicine in
                            MedicineCardView(medicine: medicine, onToggleTaken: {
                                refreshToggle.toggle()
                            })
                        }
                    }
                    
                    WaterIntakeCardView()
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    let controller = PersistenceController.init(inMemory: true)
    let context = controller.container.viewContext
    
    User.UserDummyData(viewContext: context)
    Doctor.DoctorDummyData(viewContext: context)
    Appointment.AppointmentDummyData(viewContext: context)
    Prescription.PrescriptionDummyData(viewContext: context)
    Medicine.MedicineDummyData(viewContext: context)
    
    return MedicineDetailView()
        .environment(\.managedObjectContext, context)
}
