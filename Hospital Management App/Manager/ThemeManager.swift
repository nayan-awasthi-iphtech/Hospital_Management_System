//
//  ThemeManager.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 04/08/26.
//

import SwiftUI
internal import Combine

class ThemeManager: ObservableObject {
    
    static let shared = ThemeManager()
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {}
}
