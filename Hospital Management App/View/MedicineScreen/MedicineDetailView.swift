
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
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    Text("Medicines")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 8)
                    MedicineProgressHeaderView(
                        takenCount: takenCount,
                        totalCount: totalCount
                    )
                    
                    VStack(spacing: 8) {
                        ForEach(medicines, id: \.objectID) { medicine in
                            MedicineCardView(medicine: medicine, onToggleTaken: {
                                refreshToggle.toggle()
                            })
                        }
                    }
                    
                    WaterIntakeCardView()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .navigationBarTitleDisplayMode(.inline)
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
