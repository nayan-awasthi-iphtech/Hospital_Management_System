////
////  MedicineDetailView.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 23/07/26.
////
//
import SwiftUI
internal import CoreData

struct MedicineDetailView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    @FetchRequest private var medicines: FetchedResults<Medicine>
    
    init() {
        let activeUserID = UUID(uuidString: SessionManager.shared.currentUserID ?? "") ?? UUID()
        _medicines = FetchRequest<Medicine>(
            entity: Medicine.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Medicine.name, ascending: true)],
            predicate: NSPredicate(format: "medicine_user.id == %@", activeUserID as CVarArg),
            animation: .default
        )
    }
    
    private var currentUser: User? {
        SessionManager.shared.getActiveUser(in: viewContext)
    }
    
    private var isEligibleToViewMedicines: Bool {
        guard let activeUser = currentUser else { return false }
        
        let isProfileMissing = authViewModel.isAnyDetailMissing(for: activeUser)
        
        let hasBookedAppointment: Bool
        if let appointments = activeUser.user_appointment as? Set<Appointment> {
            hasBookedAppointment = !appointments.isEmpty
        } else {
            hasBookedAppointment = false
        }
        
        return !isProfileMissing && hasBookedAppointment
    }
    
    private var totalCount: Int {
        print("📊 [Count Check] Total count: \(medicines.count)")
        return medicines.count
    }
    
    private var takenCount: Int {
        let count = medicines.filter { $0.isTaken }.count
        print("✅ [Count Check] Taken count: \(count)")
        return count
    }
    
    var body: some View {
        ZStack {
            if isEligibleToViewMedicines {
                AppBackgroundView()
                
                ScrollView(showsIndicators: false) {
                    Text("Medicines")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color.primaryText)
                        .tracking(0.5)
                    
                    VStack(spacing: 20) {
                        
                        MedicineProgressHeaderView(
                            takenCount: takenCount,
                            totalCount: totalCount
                        )
                        
                        if medicines.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "pill.circle")
                                    .font(.system(size: 44))
                                    .foregroundColor(.secondary)
                                Text("No medicines found for this user.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 30)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(medicines, id: \.objectID) { medicine in
                                    MedicineCardView(medicine: medicine, onToggleTaken: {
                                        try? viewContext.save()
                                    })
                                }
                            }
                        }
                        WaterIntakeCardView()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            } else {
                EmptyView()
            }
        }
    }
}
