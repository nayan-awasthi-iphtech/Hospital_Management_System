import SwiftUI
internal import CoreData

struct MedicalReportsDashboard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var user: User
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.date, ascending: false)],
        animation: .default
    ) private var allReports: FetchedResults<Report>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Doctor.name, ascending: true)],
        animation: .default
    ) private var doctors: FetchedResults<Doctor>
    
    @State private var searchText: String = ""
    @State private var selectedOriginFilter: String = "All"
    @State private var isShowingReportUploadSheet: Bool = false
    
    @State private var reportsToDelete: [Report] = []
    @State private var showDeleteReportConfirmation: Bool = false
    
    let filterOptions = ["All", "Patient", "Hospital"]
    
    private var processedReports: [Report] {
        allReports.filter { report in
            let belongsToUser = report.report_user?.id == user.id
            let matchesSearch = searchText.isEmpty || (report.title ?? "").localizedCaseInsensitiveContains(searchText)
            let matchesOrigin = selectedOriginFilter == "All" || report.uploadedBy == selectedOriginFilter
            
            return belongsToUser && matchesOrigin && matchesSearch
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    Color(red: 0.96, green: 0.95, blue: 0.93)
                        .ignoresSafeArea()
                    
                    RadialGradient(
                        colors: [
                            Color(red: 0.88, green: 0.81, blue: 0.72).opacity(0.40),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 400
                    )
                    .ignoresSafeArea()
                    
                    RadialGradient(
                        colors: [
                            Color(red: 0.82, green: 0.73, blue: 0.63).opacity(0.30),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 500
                    )
                    .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search by report title...", text: $searchText)
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    Picker("Filter Source", selection: $selectedOriginFilter) {
                        ForEach(filterOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    if processedReports.isEmpty {
                        ContentUnavailableView(
                            "No Records Found",
                            systemImage: "doc.text.magnifyingglass",
                            description: Text("No Clinical data recorded under this category yet.")
                        )
                        .frame(maxHeight: .infinity)
                        .background(Color.clear)
                    } else {
                        List {
                            ForEach(processedReports) { report in
                                NavigationLink(destination: PdfViewer(pdfData: report.fileData ?? Data())
                                    .environmentObject(user)
                                ) {
                                    DynamicReportRowCard(report: report)
                                        .environmentObject(user)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            }
                            .onDelete { offsets in
                                reportsToDelete = offsets.map { processedReports[$0] }
                                showDeleteReportConfirmation = true
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Medical Reports")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingReportUploadSheet = true
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
            .sheet(isPresented: $isShowingReportUploadSheet) {
                UploadReportView(currentUser: user)
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(user)
            }
            // MARK: - Explicit Confirmation Alert
            .alert(
                "Delete Medical Report",
                isPresented: $showDeleteReportConfirmation
            ) {
                Button("Delete", role: .destructive) {
                    confirmAndDelete()
                }
                Button("Cancel", role: .cancel) {
                    reportsToDelete.removeAll()
                }
            } message: {
                Text(
                    reportsToDelete.count > 1
                    ? "Are you sure you want to delete the selected reports? This action cannot be undone."
                    : "Are you sure you want to delete this medical report? This action cannot be undone."
                )
            }
        }
    }
    
    private func confirmAndDelete() {
        withAnimation {
            reportsToDelete.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error saving deletion: \(error.localizedDescription)")
            }
            
            reportsToDelete.removeAll()
        }
    }
}
