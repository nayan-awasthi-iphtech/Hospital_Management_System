//
//  UserHealthChart.swift
//  Hospital Management App
//

import SwiftUI
internal import CoreData
import Charts
internal import Combine

struct UserHealthChart: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var currentUser: User
    
    @State private var selectedMetric: Int = 0
    @State private var isSheetShowing: Bool = false
    
    // Alert state variables for dangerous BPM warning
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    // Define clean chart scale boundaries
    private let bpmMin: Double = 40
    private let bpmMax: Double = 160
    
    private let spo2Min: Double = 80
    private let spo2Max: Double = 100
    
    // Formatter to convert Date into chart label format
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    // Calculate estimated Max Heart Rate based on user's DOB (220 - age)
    private var maxHeartRate: Int {
        if let dob = currentUser.dob { // Check your entity name (user_dob, dob, etc.)
            let calculatedAge = Calendar.current.dateComponents([.year], from: dob, to: Date()).year ?? 30
            let validAge = calculatedAge > 0 ? calculatedAge : 30
            return 220 - validAge
        }
        return 220 - 30 // Default fallback (190 BPM)
    }
    
    // Read directly from Core Data relationship & sort chronologically
    private var userLogs: [HealthLog] {
        guard let set = currentUser.user_healthLog as? Set<HealthLog> else {
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
            
            // Chart Display
            if userLogs.isEmpty {
                ContentUnavailableView("No logs available", systemImage: "chart.line.uptrend.xyaxis")
                    .frame(height: 190)
            } else {
                Chart {
                    ForEach(userLogs) { log in
                        let logDate = log.date ?? Date()
                        let rawValue = (selectedMetric == 0) ? log.bpm : log.spo2
                        let themeColor: Color = (selectedMetric == 0) ? .red : .blue
                        
                        // Limits calculation
                        let currentMin = (selectedMetric == 0) ? bpmMin : spo2Min
                        let currentMax = (selectedMetric == 0) ? bpmMax : spo2Max
                        
                        // Clamp value so chart line stops at top/bottom border without stretching layout
                        let clampedValue = min(max(rawValue, currentMin), currentMax)
                        
                        let formattedText = (selectedMetric == 0)
                        ? "\(Int(rawValue))"
                        : String(format: "%.1f%%", rawValue)
                        
                        LineMark(
                            x: .value("Date", logDate),
                            y: .value("Value", clampedValue)
                        )
                        .foregroundStyle(themeColor)
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Date", logDate),
                            y: .value("Value", clampedValue)
                        )
                        .foregroundStyle(themeColor)
                        .annotation(position: .top, alignment: .center, spacing: 4) {
                            Text(formattedText)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(rawValue > currentMax ? .red : .secondary)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    rawValue > currentMax
                                    ? Color.red.opacity(0.15)
                                    : Color.clear
                                )
                                .cornerRadius(4)
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
                .chartYAxis {
                    AxisMarks(position: .trailing)
                }
                .chartYScale(domain: selectedMetric == 0 ? [bpmMin, bpmMax + 15] : [spo2Min, spo2Max + 3])
                .frame(height: 190)
                .padding(.top, 10)
                .clipped() // Ensures chart elements never draw outside the chart box
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
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveHealthLog(bpm: Double, spo2: Double, date: Date, userLogs: [HealthLog]) {
        let newLog = HealthLog(context: viewContext)
        newLog.id = UUID()
        newLog.bpm = bpm
        newLog.spo2 = spo2
        newLog.date = date
        
        newLog.healthLog_user = currentUser
        
        do {
            try viewContext.save()
            currentUser.objectWillChange.send()
            
            let intBpm = Int(bpm)
            var issues: [String] = []
            
            if intBpm > maxHeartRate {
                issues.append("• Heart Rate (\(intBpm) BPM) exceeds your calculated maximum limit (\(maxHeartRate) BPM).")
            } else if intBpm < 50 {
                issues.append("• Heart Rate (\(intBpm) BPM) is dangerously low (below 50 BPM).")
            }
            
            if spo2 < 92.0 {
                issues.append("• SpO2 level (\(String(format: "%.1f", spo2))%) is below the healthy threshold (92%).")
            } else if spo2 > 100.0 {
                issues.append("• SpO2 level (\(String(format: "%.1f", spo2))%) is invalid (cannot exceed 100%).")
            }
            
            if !issues.isEmpty {
                if issues.count > 1 {
                    alertTitle = "Critical Health Warning"
                    alertMessage = "Multiple abnormal vitals detected:\n\n" + issues.joined(separator: "\n") + "\n\nPlease seek medical attention or consult a doctor immediately."
                } else {
                    alertTitle = "Health Alert"
                    alertMessage = issues.first?
                        .replacingOccurrences(of: "• ", with: "") ?? "Abnormal reading detected."
                    alertMessage += "\n\nPlease consult a healthcare professional if this persists."
                }
                showAlert = true
            }
            
            print("Successfully saved health log for \(currentUser.name ?? "User")")
        } catch {
            print("Health log saving issue: \(error.localizedDescription)")
        }
    }
}
