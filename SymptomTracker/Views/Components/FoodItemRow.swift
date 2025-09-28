//
//  FoodItemRow.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct FoodItemRow: View {
    let food: FoodItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Food Icon
            ZStack {
                Circle()
                    .fill(food.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text(food.icon)
                    .font(.system(size: 24))
            }
            
            // Food Info
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("\(food.calories) calories")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Remove Button
            Button(action: onRemove) {
                Image(systemName: "minus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.red)
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
        )
    }
}