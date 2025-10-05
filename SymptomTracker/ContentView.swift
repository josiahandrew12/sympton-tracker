//
//  ContentView.swift
//  SymptomTracker
//
//  Created by Josiah Cornelius on 9/10/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var stateManager: AppStateManager

    var body: some View {
        if stateManager.showOnboarding {
            OnboardingFlowView()
        } else {
            switch stateManager.currentScreen {
            case .home:
                HomeScreenView()
            case .foodTracking:
                FoodTrackingView()
            case .medicationTracking:
                MedicationTrackingView()
            case .restTracking:
                RestTrackingView()
            case .therapyTracking:
                TherapyTrackingView()
            case .symptomsTracking:
                SymptomsTrackingView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AppStateManager())
}