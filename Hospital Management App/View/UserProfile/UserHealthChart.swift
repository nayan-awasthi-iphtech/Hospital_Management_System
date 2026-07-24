//
//  UserHealthChart.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 23/07/26.
//

import SwiftUI
internal import CoreData
import Charts
internal import Combine

struct UserHealthChart: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // 1. Observe the user directly so the view re-renders on user property updates
    @ObservedObject var currentUser: User
    
    @State private var selectedMetric: Int = 0
    @State private var isSheetShowing: Bool = false
    
    // Formatter to convert Date into chart label format
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    // 2. Read directly from the Core Data relationship & sort chronologically
    private var userLogs: [HealthLog] {
        guard let set = currentUser.user_healthLog as? Set<HealthLog> else {
            // Fallback iteration directly on NSSet
            let logsArray = currentUser.user_healthLog?.allObjects as? [HealthLog] ?? []
            return logsArray.sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
        }
        
        return set.sorted { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Health Vitals")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Recent Trends")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    isSheetShowing = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                }
            }
            
            // Metric Switcher
            Picker("Vitals Metric", selection: $selectedMetric) {
                Text("Heart Rate (BPM)").tag(0)
                Text("SpO2").tag(1)
            }
            .pickerStyle(.segmented)
            
            // Empty State Check
            if userLogs.isEmpty {
                ContentUnavailableView("No logs available", systemImage: "chart.line.uptrend.xyaxis")
                    .frame(height: 190)
            } else {
                // Live Chart using userLogs
                Chart {
                    ForEach(userLogs) { log in
                        let logDate = log.date ?? Date()
                        let value = (selectedMetric == 0) ? log.bpm : log.spo2
                        let themeColor: Color = (selectedMetric == 0) ? .red : .blue
                        
                        let formattedText = (selectedMetric == 0)
                            ? "\(Int(value))"
                            : String(format: "%.1f%%", value)

                        LineMark(
                            x: .value("Date", logDate),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(themeColor)
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Date", logDate),
                            y: .value("Value", value)
                        )
                        .foregroundStyle(themeColor)
                        .annotation(position: .top, alignment: .center) {
                            Text(formattedText)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel(dateFormatter.string(from: date))
                        }
                        AxisGridLine()
                    }
                }
                .chartYScale(domain: selectedMetric == 0 ? [50, 150] : [85, 100])
                .frame(height: 190)
                .padding(.vertical, 8)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.65))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.8), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
        .sheet(isPresented: $isSheetShowing) {
            UserHealthAddSheet { bpm, spo2, date in
                saveHealthLog(bpm: bpm, spo2: spo2, date: date, userLogs: userLogs)
            }
        }
    }
    
    // Save New Health Log
    private func saveHealthLog(bpm: Double, spo2: Double, date: Date, userLogs: [HealthLog]) {
        let newLog = HealthLog(context: viewContext)
        newLog.id = UUID()
        newLog.bpm = bpm
        newLog.spo2 = spo2
        newLog.date = date
        
        // Relate the new log to current user
        newLog.healthLog_user = currentUser
        print("User log \(userLogs.count)")
        
        do {
            try viewContext.save()
            // Tell SwiftUI the user object changed so the userLogs array refreshes immediately
            currentUser.objectWillChange.send()
            print("Successfully saved health log for \(currentUser.name ?? "User")")
        } catch {
            print("Health log saving issue: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let request: NSFetchRequest<User> = User.fetchRequest()
    let sampleUser = (try? context.fetch(request))?.first ?? User(context: context)
    
    ZStack {
        Color(red: 0.96, green: 0.95, blue: 0.93)
            .ignoresSafeArea()
        UserHealthChart(currentUser: sampleUser)
            .environment(\.managedObjectContext, context)
    }
}
