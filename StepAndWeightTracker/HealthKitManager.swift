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
    
    func fetchStepCount() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
                            
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("*** Unable to calculate the end time ***")
        }
        
        guard let startDate = calendar.date(byAdding: .day, value: -28, to: endDate) else {
            fatalError("*** Unable to calculate the start time ***")
        }
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsLast28DaysPredicate =  HKSamplePredicate.quantitySample(
            type: HKQuantityType(.stepCount),
            predicate: queryPredicate)
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: stepsLast28DaysPredicate,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: .init(day: 1)
            )
        
        let stepCounts = try! await sumOfStepsQuery.result(for: store)
        
//        for step in stepCounts.statistics() {
//            print(step.sumQuantity() ?? 0)
//        }
    }
    
    func fetchWeight() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("*** Unable to calculate the end time ***")
        }
        
        guard let startDate = calendar.date(byAdding: .day, value: -28, to: endDate) else {
            fatalError("*** Unable to calculate the start time ***")
        }
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let weightLast28DaysPredicate =  HKSamplePredicate.quantitySample(
            type: HKQuantityType(.bodyMass),
            predicate: queryPredicate)
        let sumOfWeightsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: weightLast28DaysPredicate,
            options: .mostRecent,
            anchorDate: endDate,
            intervalComponents: .init(day: 1)
        )
        
        let weightCounts = try! await sumOfWeightsQuery.result(for: store)
        
//        for weight in weightCounts.statistics() {
//            print("Weight: \(weight.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)")
//        }
    }
    
    func addSimulatorData() async {
        var mockSamples: [HKQuantitySample] = []
        
        for i in 0..<28 {
            let stepQuantity = HKQuantity(unit: .count(),
                                          doubleValue: .random(in: 4_000...20_000))
            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
            let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: startDate)!
            let stepSample = HKQuantitySample(
                type: HKQuantityType(.stepCount),
                quantity: stepQuantity,
                start: startDate,
                end: endDate
            )
            mockSamples.append(stepSample)
            
            let randomRangeWeight = (160+Double(i/3))...165+Double(i/3)
            let weightQuantity = HKQuantity(unit: .pound(),
                                            doubleValue: .random(in: randomRangeWeight))
            
            let weightSample = HKQuantitySample(
                type: HKQuantityType(.bodyMass),
                quantity: weightQuantity,
                start: startDate,
                end: endDate
            )
            mockSamples.append(weightSample)
        }
        
        try! await store.save(mockSamples)
        print("✅ Dummy data uploaded successful")
    }
}
