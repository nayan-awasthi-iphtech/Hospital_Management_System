//
//  UploadReportView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 20/07/26.
//

import SwiftUI
internal import CoreData
import UniformTypeIdentifiers

struct UploadReportSheet: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var reportViewModel: ReportViewModel
    @StateObject private var doctorViewModel = DoctorViewModel()
    
    let currentUser: User
    
    var body: some View {
        NavigationStack {
            ZStack{
                AppBackgroundView()
                Form {
                    Section(header: Text("Report Details")) {
                        TextField("Enter the Title (e.g., Blood Test)", text: $reportViewModel.reportTitle)
                        
                        Picker("Category Type", selection: $reportViewModel.reportCategory) {
                            ForEach(reportViewModel.categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                    }
                    
                    Section(header: Text("Associated Doctor")) {
                        if doctorViewModel.doctors.isEmpty {
                            Text("No doctors available")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Picker("Select Doctor", selection: $reportViewModel.selectedDoctor) {
                                Text("None").tag(Doctor?.none)
                                ForEach(doctorViewModel.doctors, id: \.objectID) { doctor in
                                    Text(doctor.name ?? "Dr. Unknown")
                                        .tag(Optional(doctor))
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Upload Source")) {
                        Picker("Uploaded By", selection: $reportViewModel.reportSource) {
                            ForEach(reportViewModel.sources, id: \.self) { source in
                                Text(source)
                            }
                        }
                    }
                    
                    Section(header: Text("Attachment")) {
                        Button(action: {
                            reportViewModel.isFilePickerPresented = true
                        }) {
                            HStack {
                                Image(systemName: reportViewModel.isFileSelected ? "doc.circle.fill" : "doc.badge.plus")
                                    .foregroundColor(reportViewModel.isFileSelected ? .green : .blue)
                                    .font(.system(size: 18))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(reportViewModel.isFileSelected ? "File Attached" : "Tap to Choose PDF")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text(reportViewModel.selectedFileName)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                if !reportViewModel.isFileSelected {
                                    Text("Upload")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("New Medical Report")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            reportViewModel.saveReport(context: viewContext, currentUser: currentUser){_ in
                                dismiss()
                            }
                        }
                        .font(.system(size: 16, weight: .bold))
                        .disabled(reportViewModel.reportTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !reportViewModel.isFileSelected)
                    }
                }
            }
            .fileImporter(isPresented: $reportViewModel.isFilePickerPresented, allowedContentTypes: [.pdf], allowsMultipleSelection: false) { result in
                switch result {
                case .success(let urls):
                    guard let fileURL = urls.first else { return }
                    
                    if fileURL.startAccessingSecurityScopedResource() {
                        defer { fileURL.stopAccessingSecurityScopedResource() }
                        
                        if let data = try? Data(contentsOf: fileURL) {
                            reportViewModel.selectedPDFData = data
                            reportViewModel.selectedFileName = fileURL.lastPathComponent
                            reportViewModel.isFileSelected = true
                        }
                    }
                    
                case .failure(let error):
                    print("File Selection Error: \(error.localizedDescription)")
                }
            }
            .onAppear {
                if reportViewModel.selectedDoctor == nil && !doctorViewModel.doctors.isEmpty {
                    reportViewModel.selectedDoctor = doctorViewModel.doctors.first
                }
            }
        }
    }
}

#Preview {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let previewUser: User = {
        let user = User(context: context)
        user.id = UUID()
        user.name = "Preview User"
        user.email = "preview@example.com"
        return user
    }()
    return UploadReportSheet(currentUser: previewUser)
}
