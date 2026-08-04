//
//  AppColors.swift
//  Hospital Management App
//
//  Created by iPHTech 30 on 04/08/26.
//

import SwiftUI
import UIKit

extension Color {
    
    private static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
    
    static let appBackground = adaptive(
        light: UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1),
        dark: UIColor(red: 0.13, green: 0.11, blue: 0.09, alpha: 1)
    )
    
    static let appBackgroundTintTop = adaptive(
        light: UIColor(red: 0.88, green: 0.81, blue: 0.72, alpha: 0.40),
        dark: UIColor(red: 0.30, green: 0.24, blue: 0.17, alpha: 0.30)
    )
    
    static let appBackgroundTintCenter = adaptive(
        light: UIColor(red: 0.82, green: 0.73, blue: 0.63, alpha: 0.30),
        dark: UIColor(red: 0.24, green: 0.19, blue: 0.14, alpha: 0.25)
    )
    
    static let primaryText = adaptive(
        light: UIColor(red: 0.10, green: 0.10, blue: 0.12, alpha: 1),
        dark: UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1)
    )
    
    static let secondaryText = adaptive(
        light: UIColor(red: 0.45, green: 0.38, blue: 0.32, alpha: 1),
        dark: UIColor(red: 0.75, green: 0.70, blue: 0.62, alpha: 1)
    )
    
    static let accentBrown = adaptive(
        light: UIColor(red: 0.45, green: 0.32, blue: 0.22, alpha: 1),
        dark: UIColor(red: 0.85, green: 0.70, blue: 0.55, alpha: 1)
    )
    
    static let cardBackground = adaptive(
        light: UIColor.white,
        dark: UIColor(red: 0.20, green: 0.17, blue: 0.14, alpha: 1)
    )
    
    static let cardBorder = adaptive(
        light: UIColor.white,
        dark: UIColor(red: 0.55, green: 0.47, blue: 0.40, alpha: 0.8)
    )
    
    static let headerGradientStart = adaptive(
        light: UIColor(red: 0.72, green: 0.58, blue: 0.46, alpha: 1),
        dark: UIColor(red: 0.62, green: 0.49, blue: 0.38, alpha: 1)
    )
    
    static let headerGradientEnd = adaptive(
        light: UIColor(red: 0.55, green: 0.41, blue: 0.30, alpha: 1),
        dark: UIColor(red: 0.47, green: 0.35, blue: 0.26, alpha: 1)
    )
    
    static let goldAmber = adaptive(
        light: UIColor(red: 0.90, green: 0.66, blue: 0.22, alpha: 1),
        dark: UIColor(red: 0.98, green: 0.80, blue: 0.35, alpha: 1)
    )
}
