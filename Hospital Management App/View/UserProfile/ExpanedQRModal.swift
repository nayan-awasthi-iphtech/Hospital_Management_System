////
////  ExpanedQRModal.swift
////  Hospital Management App
////
////  Created by iPHTech 30 on 21/07/26.
////
//import SwiftUI
//
//struct ExpandedQRModalView: View {
//    @Binding var isPresented: Bool
//    let patientName: String
//    let patientID: String
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.85)
//                .ignoresSafeArea()
//                .onTapGesture {
//                    dismissModal()
//                }
//            
//            VStack(spacing: 24) {
//                
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        dismissModal()
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .font(.system(size: 30))
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding(.horizontal, 24)
//                
//                Spacer()
//                
//                VStack(spacing: 20) {
//                    VStack(spacing: 4) {
//                        Text(patientName)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.primary)
//                        
//                        Text("ID: \(patientID)")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.center)
//                            .lineLimit(1)
//                    }
//                    
//                    Image(systemName: "qrcode")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 230, height: 230)
//                        .padding(20)
//                        .background(Color.white)
//                        .cornerRadius(20)
//                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
//                    
//                    Label("Scan for Hospital Payments", systemImage: "checkmark.seal.fill")
//                        .font(.footnote)
//                        .fontWeight(.medium)
//                        .foregroundColor(.blue)
//                }
//                .padding(28)
//                .background(Color(.systemBackground))
//                .cornerRadius(28)
//                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
//                .padding(.horizontal, 28)
//                
//                Spacer()
//                
//                Text("Tap anywhere to close")
//                    .font(.footnote)
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.bottom, 20)
//            }
//        }
//    }
//    
//    private func dismissModal() {
//        withAnimation(.easeInOut(duration: 0.2)) {
//            isPresented = false
//        }
//    }
//}


//
//  ExpandedQRModalView.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 21/07/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ExpandedQRModalView: View {
    @Binding var isPresented: Bool
    let patientName: String
    let patientID: String
    
    // CoreImage context for generating the QR image
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissModal()
                }
            
            VStack(spacing: 24) {
                
                HStack {
                    Spacer()
                    Button(action: {
                        dismissModal()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text(patientName)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Text("ID: \(patientID)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                    
                    // REAL, SCANNABLE QR CODE
                    if let qrImage = generateQRCode(from: patientID) {
                        Image(uiImage: qrImage)
                            .resizable()
                            .interpolation(.none) // Keeps edges sharp & crisp, not blurry
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    } else {
                        // Fallback if encoding fails
                        Image(systemName: "xmark.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                            .foregroundColor(.gray)
                    }
                    
                    Label("Scan for Hospital Payments", systemImage: "checkmark.seal.fill")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .padding(28)
                .background(Color(.systemBackground))
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 28)
                
                Spacer()
                
                Text("Tap anywhere to close")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.bottom, 20)
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
          
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return nil
    }
    
    private func dismissModal() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
        }
    }
}
