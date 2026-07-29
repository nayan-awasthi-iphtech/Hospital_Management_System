//
//  ReportViewModel.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 29/07/26.
//

import Foundation
internal import CoreData
internal import Combine
import SwiftUI

class ReportViewModel : ObservableObject {
    
    // for uploading a report
    @Published var reportTitle: String = ""
    @Published var reportCategory: String = "Pathology"
    @Published var reportSource: String = "Patient"
    @Published var selectedDoctor: Doctor? = nil
    @Published var selectedPDFData: Data? = nil
    @Published var selectedFileName: String = "No file Chosen"
    @Published var isFileSelected: Bool = false
    @Published var isFilePickerPresented: Bool = false
    
    // for dashboard view
    @Published var searchText: String = ""
    @Published var selectedOriginFilter: String = "All"
    @Published var reportsToDelete: [Report] = []
    @Published var showDeleteConfirmation: Bool = false
    
    let categories = ["Pathology", "Radiology", "Cardiology", "General Checkup"]
    let sources = ["Patient", "Hospital"]
    let filterOptions = ["All", "Hospital", "Patient"]
    
    func filterReports(from allReports: FetchedResults<Report>, currentUser: User) -> [Report]{
        allReports.filter { report in
            let belongToCurrentUser = report.report_user?.id == currentUser.id
            let matchedSearch = searchText.isEmpty || (report.title ?? "").localizedCaseInsensitiveContains(searchText)
            let matchesOrigin = selectedOriginFilter == "All" || report.uploadedBy == selectedOriginFilter
             return belongToCurrentUser && matchedSearch && matchesOrigin
        }
    }
    
    func saveReport(context: NSManagedObjectContext, currentUser: User, onSuccess: @escaping (Report) -> Void) {
        guard let pdfData = selectedPDFData, !reportTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newReport = Report(context: context)
        newReport.id = UUID()
        newReport.title = reportTitle
        newReport.reportType = reportCategory
        newReport.uploadedBy = reportSource
        newReport.date = Date()
        newReport.fileData = pdfData
        
        newReport.report_user = currentUser
        currentUser.addToUser_report(newReport)
        
        if let doctor = selectedDoctor {
            newReport.report_doctor = doctor
            doctor.addToDoctor_report(newReport)
        }
        
        do {
            try context.save()
            resetUploadForm()
            onSuccess(newReport)
            print("Report saved successfuly")
        } catch {
            print("Error in saving report: \(error.localizedDescription)")
        }
    }
    
    func prepareForDelete(at offsets: IndexSet, from reportList: [Report]){
        reportsToDelete = offsets.map { reportList[$0]}
        showDeleteConfirmation = true
    }
    
    func confirmAndDelete(context: NSManagedObjectContext) {
        guard !reportsToDelete.isEmpty else { return }
        
        reportsToDelete.forEach(context.delete)
        
        do {
            try context.save()
            print("Report Deleted Sucessfuly")
        } catch {
            print("Error in Deleting the report:\(error.localizedDescription)")
        }
        reportsToDelete.removeAll()
    }
    
    func resetUploadForm(){
        reportTitle = ""
        reportCategory = "Pathalogy"
        reportSource = "Patient"
        selectedDoctor = nil
        selectedPDFData = nil
        selectedFileName = "No file Choosen"
        isFileSelected = false
    }
}
