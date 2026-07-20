//
//  PdfViewer.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 20/07/26.
//

import SwiftUI
import PDFKit

struct PdfViewer: UIViewRepresentable {
    let pdfData: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        
        if let document = PDFDocument(data: pdfData) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
}
