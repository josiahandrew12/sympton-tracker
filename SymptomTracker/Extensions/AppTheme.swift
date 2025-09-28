//
//  AppTheme.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

// MARK: - App Theme Constants
struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary dark theme colors
        static let primaryBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
        static let secondaryBackground = Color(red: 0.15, green: 0.15, blue: 0.15)
        static let cardBackground = Color(red: 0.15, green: 0.15, blue: 0.15)
        
        // Text colors
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.7)
        static let tertiaryText = Color.white.opacity(0.5)
        
        // Accent colors
        static let accentBlue = Color.blue
        static let accentGreen = Color.green
        static let accentPurple = Color.purple
        static let accentOrange = Color.orange
        static let accentRed = Color.red
        
        // Interactive colors
        static let buttonBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
        static let borderColor = Color.white.opacity(0.2)
        static let shadowColor = Color.black.opacity(0.3)
        
        // System colors for consistency
        static let searchBarBackground = Color.gray.opacity(0.3)
        static let placeholderBackground = Color.gray.opacity(0.3)
    }
    
    // MARK: - Layout Constants
    struct Layout {
        // Apple HIG minimum hit target
        static let minimumHitTarget: CGFloat = 44
        
        // Common frame sizes
        static let iconFrame: CGFloat = 44
        static let smallIconFrame: CGFloat = 40
        static let largeIconFrame: CGFloat = 60
        
        // Spacing
        static let paddingSmall: CGFloat = 8
        static let paddingMedium: CGFloat = 16
        static let paddingLarge: CGFloat = 24
        static let paddingXLarge: CGFloat = 40
        
        // Corner radius
        static let cornerRadiusSmall: CGFloat = 8
        static let cornerRadiusMedium: CGFloat = 12
        static let cornerRadiusLarge: CGFloat = 16
        
        // Shadow
        static let shadowRadius: CGFloat = 8
        static let shadowOffset: CGFloat = 2
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 28, weight: .bold)
        static let title = Font.system(size: 24, weight: .bold)
        static let headline = Font.system(size: 20, weight: .semibold)
        static let body = Font.system(size: 16, weight: .regular)
        static let caption = Font.system(size: 14, weight: .medium)
        static let smallCaption = Font.system(size: 12, weight: .regular)
        static let buttonText = Font.system(size: 16, weight: .medium)
    }
    
    // MARK: - Animation
    struct Animation {
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let fast = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
    }
}

// MARK: - View Modifiers
extension View {
    /// Apply standard card styling
    func cardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadiusMedium)
                    .fill(AppTheme.Colors.cardBackground)
                    .shadow(
                        color: AppTheme.Colors.shadowColor,
                        radius: AppTheme.Layout.shadowRadius,
                        x: 0,
                        y: AppTheme.Layout.shadowOffset
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadiusMedium)
                    .stroke(AppTheme.Colors.borderColor, lineWidth: 1)
            )
    }
    
    /// Apply standard button styling
    func buttonStyle() -> some View {
        self
            .font(AppTheme.Typography.buttonText)
            .foregroundColor(AppTheme.Colors.primaryText)
            .padding(.horizontal, AppTheme.Layout.paddingXLarge)
            .padding(.vertical, AppTheme.Layout.paddingMedium)
            .background(AppTheme.Colors.buttonBackground)
            .cornerRadius(AppTheme.Layout.cornerRadiusMedium)
    }
    
    /// Apply standard icon frame
    func iconFrame() -> some View {
        self.frame(width: AppTheme.Layout.iconFrame, height: AppTheme.Layout.iconFrame)
    }
    
    /// Apply standard small icon frame
    func smallIconFrame() -> some View {
        self.frame(width: AppTheme.Layout.smallIconFrame, height: AppTheme.Layout.smallIconFrame)
    }
}
