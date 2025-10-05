//
//  FoodTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct FoodTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var selectedMealType = "Breakfast"
    @State private var foodName = ""
    @State private var showingAddFood = false
    
    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    private func mealEmoji(for mealType: String) -> String {
        switch mealType {
        case "Breakfast": return "🍳"
        case "Lunch": return "🥗"
        case "Dinner": return "🍽️"
        case "Snack": return "🍿"
        default: return "🍴"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            stateManager.navigateTo(.home)
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Food Tracking")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Empty space for symmetry
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Meal Type Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(mealTypes, id: \.self) { mealType in
                                Button(action: {
                                    selectedMealType = mealType
                                }) {
                                    Text(mealType)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(selectedMealType == mealType ? .white : .white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(selectedMealType == mealType ? Color.blue : Color.gray.opacity(0.3))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                    
                    // Add Food Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Add \(selectedMealType)")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            Text(mealEmoji(for: selectedMealType))
                                .font(.system(size: 64))
                            
                            VStack(spacing: 12) {
                                TextField("Food name", text: $foodName)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.3))
                                    )
                                
                                Button(action: {
                                    if !foodName.isEmpty {
                                        stateManager.addTimelineEntry(
                                            type: .food,
                                            title: selectedMealType,
                                            subtitle: foodName,
                                            icon: mealEmoji(for: selectedMealType)
                                        )
                                        foodName = ""
                                        stateManager.navigateTo(.home)
                                    }
                                }) {
                                    Text("Save \(selectedMealType)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(foodName.isEmpty ? Color.gray.opacity(0.3) : Color.green)
                                        )
                                }
                                .disabled(foodName.isEmpty)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                        )
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.black)
        }
    }
}