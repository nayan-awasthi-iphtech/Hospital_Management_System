//
//  UserHealthAddSheet.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 23/07/26.
//

import SwiftUI

struct UserHealthAddSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    @State private var bpmText: String = ""
    @State private var spo2Text: String = ""
    
    var onSave: (_ bpm: Double, _ spo2: Double, _ date: Date) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(
                        "Enter Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                } header: {
                    Text("Log Date")
                } footer: {
                    Text("Select the date for this reading.")
                }
                
                Section {
                    HStack {
                        Label("Heart Rate", systemImage: "heart.fill")
                            .foregroundStyle(.red)
                        
                        Spacer()
                        
                        TextField("e.g. 73", text: $bpmText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        
                        Text("BPM")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Label("Blood Oxygen", systemImage: "waveform.path.ecg")
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        TextField("e.g. 98", text: $spo2Text)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        
                        Text("%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Vitals Measurement")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.96, green: 0.95, blue: 0.93))
            .navigationTitle("Add Vitals Reading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let bpm = Double(bpmText), let spo2 = Double(spo2Text) {
                            onSave(bpm, spo2, selectedDate)
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(bpmText.isEmpty || spo2Text.isEmpty)
                }
            }
        }
    }
}

#Preview {
    UserHealthAddSheet { bpm, spo2, date in
        print("Logged: \(bpm) BPM, \(spo2)% on \(date)")
    }
}
