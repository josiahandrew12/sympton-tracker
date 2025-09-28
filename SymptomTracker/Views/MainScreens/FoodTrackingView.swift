//
//  FoodTrackingView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI

struct FoodTrackingView: View {
    @EnvironmentObject var stateManager: AppStateManager
    @State private var searchText = ""
    @State private var selectedMealType = "Breakfast"
    @State private var selectedFoods: [FoodItem] = []
    @State private var showingAddFood = false
    
    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"]
    private let recentFoods = [
        FoodItem(name: "Apple, medium", calories: 95, icon: "🍎", color: .red),
        FoodItem(name: "Caesar Salad", calories: 320, icon: "🥗", color: .green),
        FoodItem(name: "Whole wheat bread", calories: 80, icon: "🍞", color: .yellow),
        FoodItem(name: "Banana, large", calories: 121, icon: "🍌", color: .purple),
        FoodItem(name: "Milk, 2% fat", calories: 122, icon: "🥛", color: .blue)
    ]
    
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
                        
                        Button(action: {
                            showingAddFood = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        
                        TextField("Search foods...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                    )
                    .padding(.horizontal, 24)
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
                    .padding(.bottom, 20)
                    
                    // Quick Add Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Quick Add")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(recentFoods, id: \.id) { food in
                                    QuickAddButton(food: food) {
                                        stateManager.addFoodItem(food)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 24)
                    
                    // Selected Foods
                    if !selectedFoods.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Today's \(selectedMealType)")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(selectedFoods.reduce(0) { $0 + $1.calories }) cal")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(spacing: 12) {
                                ForEach(selectedFoods, id: \.id) { food in
                                    FoodItemRow(food: food) {
                                        selectedFoods.removeAll { $0.id == food.id }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.bottom, 24)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.black)
        }
        .sheet(isPresented: $showingAddFood) {
            // Add custom food view would go here
            Text("Add Custom Food")
                .presentationDetents([.medium])
        }
    }
}