//
//  ImagePicker.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 31/07/26.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    
    @Binding var selectedImageData: Data?
    @State var selectedPhotItem: PhotosPickerItem? = nil
    var body: some View {
        VStack(spacing:12){
            PhotosPicker(selection: $selectedPhotItem, matching: .images){
                ZStack(alignment: .bottomTrailing){
                    if let data = selectedImageData, let uiImage = UIImage(data: data){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
            }
            .onChange(of: selectedPhotItem){
                Task{
                    if let data = try? await selectedPhotItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data),
                        let compressedData = uiImage.jpegData(compressionQuality: 0.7){
                        await MainActor.run {
                            selectedImageData = compressedData
                        }
                    }
                }
            }
            Text("Tap to change the profile picture")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ImagePicker(selectedImageData: .constant(nil), selectedPhotItem: nil)
}
