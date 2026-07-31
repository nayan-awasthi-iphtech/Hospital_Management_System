import SwiftUI
internal import CoreData

struct MedicalReportsDashboard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var currentUser: User
    
    @StateObject private var viewModel = ReportViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.date, ascending: false)],
        animation: .default
    ) private var allReports: FetchedResults<Report>

    @State private var isShowingReportUploadSheet: Bool = false
    
    private var processedReports: [Report] {
        viewModel.filterReports(from: allReports, currentUser: currentUser)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search by report title...", text: $viewModel.searchText)
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    Picker("Filter Source", selection: $viewModel.selectedOriginFilter) {
                        ForEach(viewModel.filterOptions, id: \.self) { option in
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
                                    .environmentObject(currentUser)
                                ) {
                                    DynamicReportRowCard(report: report)
                                        .environmentObject(currentUser)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            }
                            .onDelete { offsets in
                                viewModel.prepareForDelete(at: offsets, from: processedReports)
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
                UploadReportSheet(currentUser: currentUser)
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(currentUser)
                    .environmentObject(viewModel)
            }
            .alert(
                "Delete Medical Report",
                isPresented: $viewModel.showDeleteConfirmation
            ) {
                Button("Delete", role: .destructive) {
                    viewModel.confirmAndDelete(context: viewContext)
                }
                Button("Cancel", role: .cancel) {
                    viewModel.reportTitle.removeAll()
                }
            } message: {
                Text(
                    viewModel.reportsToDelete.count > 1
                    ? "Are you sure you want to delete the selected reports? This action cannot be undone."
                    : "Are you sure you want to delete this medical report? This action cannot be undone."
                )
            }
        }
    }
}
