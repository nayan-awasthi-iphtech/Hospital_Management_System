//
//  ReportRowCardView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 20/07/26.
//

import SwiftUI
internal import CoreData

struct DynamicReportRowCard: View {
    @ObservedObject var report: Report
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Color.blue.opacity(0.1)
                    .frame(width: 50, height: 50)
                    .cornerRadius(12)
                Image(systemName: report.uploadedBy == "Hospital" ? "building.md.fill" : "person.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(report.title ?? "Clinical Diagnostics")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "stethoscope")
                    Text(report.report_doctor?.name ?? "External Consultant")
                }
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                
                Text(report.date?.formatted(date: .long, time: .omitted) ?? "")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // UploadedBy Identifier Badge Markup
            Text(report.reportType ?? "General")
                .font(.system(size: 11, weight: .bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(6)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let sampleReport = Report(context: context)
    
    sampleReport.title = "Blood Count"
    sampleReport.uploadedBy = "Hospital"
    sampleReport.reportType = "Pathalogy"
    
   return DynamicReportRowCard(report: sampleReport)
        .padding()
        .background(Color(.systemGroupedBackground))
}
