//
//  MedicalReportsDashboard.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 20/07/26.
//

import SwiftUI
internal import CoreData

struct MedicalReportsDashboard: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)]
    ) private var users: FetchedResults<User>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Report.date, ascending: false)],
        animation: .default
    ) private var allReports: FetchedResults<Report>
    
    @State private var searchText: String = ""
    @State private var selectedOriginFilter: String = "All"
    @State private var isShowingReportUploadSheet: Bool = false
    
    let filterOptions = ["All", "Patient", "Hospital"]
    
    var body: some View {
        let currentUser = users.first
        
        NavigationStack{
            VStack(){
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search by report title...", text: $searchText)
                }
                .padding(12)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                Picker("Filter Source", selection: $selectedOriginFilter){
                    ForEach(filterOptions, id: \.self){ option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                let processedReports = dynamicFilterSearch(for: currentUser)
                
                if processedReports.isEmpty{
                    ContentUnavailableView(
                        "No Records Found",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("No Clinical data recorded under this category yet."
                                         )
                    )
                    .frame(maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    List {
                        ForEach(processedReports){ report in
                            NavigationLink(destination: PdfViewer(pdfData: report.fileData ?? Data())){
                                DynamicReportRowCard(report: report)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete(perform: { offsets in
                            deleteReportsNodes(at: offsets, from: processedReports)
                        })
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Medical Reports")
            .background(Color(.systemGroupedBackground))
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        isShowingReportUploadSheet = true
                    } label: {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
            .sheet(isPresented:$isShowingReportUploadSheet){
                if let activeUser = currentUser {
                    UploadReportView(currentUser: activeUser)
                        .environment(\.managedObjectContext, viewContext)
                } else {
                    ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text("No active user session found"))
                }
            }
        }
    }
    
    private func dynamicFilterSearch(for user: User?) -> [Report]{
        guard let activeUser = user else { return [] }
        
        return allReports.filter{report in
            let belongsToUser = report.report_user?.id == activeUser.id
            let matchesSearch = searchText.isEmpty || (report.title ?? "").localizedCaseInsensitiveContains(searchText)
            let matchesOrigin =  selectedOriginFilter == "All" || report.uploadedBy == selectedOriginFilter
            
            return belongsToUser && matchesOrigin && matchesSearch
        }
    }
    
    private func deleteReportsNodes(at offsets: IndexSet, from datasource: [Report]){
        withAnimation{
            offsets.map { datasource[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}

#Preview{
    MedicalReportsDashboard()
}
