//
//  UploadReportView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 20/07/26.
//

import SwiftUI
internal import CoreData
import UniformTypeIdentifiers

struct UploadReportView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    let currentUser: User
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Doctor.name, ascending: true)],
        animation: .default
    ) private var doctors: FetchedResults<Doctor>
    
    @State private var reportTitle: String = ""
    @State private var reportCategory: String = "Pathology"
    @State private var reportSource: String = "Patient"
    @State private var isFilePickerPresented: Bool = false
    @State private var selectedFileName: String = "No file Chosen"
    @State private var selectedDoctor: Doctor? = nil
    @State private var isFileSelected: Bool = false
    @State private var selectedPDFData: Data? = nil
    
    let categories = ["Pathology", "Radiology", "Cardiology", "General Checkup"]
    let sources = ["Patient", "Hospital"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Report Details")) {
                    TextField("Enter the Title (e.g., Blood Test)", text: $reportTitle)
                    
                    Picker("Category Type", selection: $reportCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                
                Section(header: Text("Upload Source")) {
                    Picker("Uploaded By", selection: $reportSource) {
                        ForEach(sources, id: \.self) { source in
                            Text(source)
                        }
                    }
                }
                
                Section(header: Text("Attachment")) {
                    Button(action: {
                        isFilePickerPresented = true
                    }) {
                        HStack {
                            // 💡 Visual Fix: Green indicator toggles ONLY when a file is successfully selected
                            Image(systemName: isFileSelected ? "doc.circle.fill" : "doc.badge.plus")
                                .foregroundColor(isFileSelected ? .green : .blue)
                                .font(.system(size: 18))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(isFileSelected ? "File Attached" : "Tap to Choose PDF")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(selectedFileName)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            if !isFileSelected {
                                Text("Upload")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("New Medical Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let pdfDataBlock = selectedPDFData {
                            ReportDataManager.saveDynamicReport(
                                viewContext: viewContext,
                                currentUser: currentUser,
                                reportTitle: reportTitle,
                                reportCategory: reportCategory,
                                reportSource: reportSource,
                                selectedDoctor: selectedDoctor,
                                selectedPDFData: pdfDataBlock,
                            ) {
                                dismiss()
                            }
                        }
                    }
                    .font(.system(size: 16, weight: .bold))
                    .disabled(reportTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !isFileSelected)
                }
            }
        }
        .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.pdf], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                guard let fileURL = urls.first else { return }
                
                if fileURL.startAccessingSecurityScopedResource() {
                    defer { fileURL.stopAccessingSecurityScopedResource() }
                    
                    if let data = try? Data(contentsOf: fileURL) {
                        self.selectedPDFData = data
                        self.selectedFileName = fileURL.lastPathComponent
                        self.isFileSelected = true // 💡 Setting selection state flag to true
                    }
                }
                
            case .failure(let error):
                print("File Selection Error: \(error.localizedDescription)")
            }
        }
        .onAppear {
            if selectedDoctor == nil && !doctors.isEmpty {
                selectedDoctor = doctors.first
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
    return UploadReportView(currentUser: previewUser)
}
