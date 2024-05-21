//
//  StepAndWeightTrackerApp.swift
//  StepAndWeightTracker
//
//  Created by Dariy Kutelov on 8.05.24.
//

import SwiftUI

@main
struct StepAndWeightTrackerApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
