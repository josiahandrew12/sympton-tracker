//
//  SelectableCardProtocol.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

// MARK: - Selectable Card Protocol
protocol SelectableCard {
    var isSelected: Bool { get }
    var icon: String { get }
    var title: String { get }
    var color: Color { get }
    var onTap: () -> Void { get }
}

// MARK: - Default Implementation
extension SelectableCard {
    var cardBackground: Color {
        AppTheme.Colors.cardBackground
    }
    
    var iconBackground: Color {
        isSelected ? color.opacity(0.2) : color.opacity(0.1)
    }
    
    var iconForeground: Color {
        isSelected ? color : color.opacity(0.7)
    }
    
    var titleColor: Color {
        AppTheme.Colors.primaryText
    }
    
    var cardBorder: Color {
        AppTheme.Colors.borderColor
    }
    
    var shadowColor: Color {
        AppTheme.Colors.shadowColor
    }
}

// MARK: - Standard Selectable Card View
struct StandardSelectableCard: View {
    let card: any SelectableCard
    
    var body: some View {
        Button(action: card.onTap) {
            HStack(spacing: AppTheme.Layout.paddingMedium) {
                // Icon
                ZStack {
                    Circle()
                        .fill(card.iconBackground)
                        .iconFrame()
                    
                    Image(systemName: card.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(card.iconForeground)
                }
                
                // Title
                Text(card.title)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(card.titleColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Selection indicator
                if card.isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.accentBlue)
                        .font(.system(size: 20))
                }
            }
            .padding(AppTheme.Layout.paddingMedium)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Compact Selectable Card View
struct CompactSelectableCard: View {
    let card: any SelectableCard
    
    var body: some View {
        Button(action: card.onTap) {
            VStack(spacing: AppTheme.Layout.paddingSmall) {
                // Icon
                ZStack {
                    Circle()
                        .fill(card.iconBackground)
                        .iconFrame()
                    
                    Image(systemName: card.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(card.iconForeground)
                }
                
                // Title
                Text(card.title)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(card.titleColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(AppTheme.Layout.paddingSmall)
            .frame(minWidth: 80, minHeight: 80)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
