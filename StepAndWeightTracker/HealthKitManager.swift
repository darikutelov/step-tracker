//
//  HealthKitManager.swift
//  StepAndWeightTracker
//
//  Created by Dariy Kutelov on 18.05.24.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
