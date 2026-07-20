//
//  SaveDataHelper.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 20/07/26.
//

internal import CoreData
import Foundation

class ReportDataManager {
    static func saveDynamicReport(
        viewContext: NSManagedObjectContext,
        currentUser: User,
        reportTitle: String,
        reportCategory: String,
        reportSource: String,
        selectedDoctor: Doctor?,
        selectedPDFData: Data?,
        dismiss: @escaping () -> Void
    ){
        guard let pdfDataBlock = selectedPDFData else { return }
        
        let newReport = Report(context: viewContext)
        newReport.id = UUID()
        newReport.title = reportTitle
        newReport.reportType = reportCategory
        newReport.uploadedBy = reportSource
        newReport.date = Date()
        newReport.fileData = pdfDataBlock
        
        newReport.report_user = currentUser
        currentUser.addToUser_report(newReport)
        
        if let linkedDoctor = selectedDoctor {
            newReport.report_doctor = linkedDoctor
            linkedDoctor.addToDoctor_report(newReport)
        }
        
        do {
            try viewContext.save()
            print("Core Data Transaction Successful")
            dismiss()
        } catch {
            print("write Transaction Failed: \(error.localizedDescription)")
        }
    }
}
