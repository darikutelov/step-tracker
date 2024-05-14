//
//  HealthKitPermissionPrimingView.swift
//  StepAndWeightTracker
//
//  Created by Dariy Kutelov on 14.05.24.
//

import SwiftUI

struct HealthKitPermissionPrimingView: View {
    
    var description = """
    Thid app displays your step and weight data in interactive charts.
    
    You can also add new step or weight data to Apple Health from this app. Your data is private and secure.
    """
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 12) {
                Image(.appleHealthIcon)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                Text("Apple Health Integration")
                    .font(.title2).bold()
                Text(description)
                    .foregroundStyle(.secondary)
            }
            Button("Connect Apple Health") {
                //TODO: - connect to HealthKit
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(30)
    }
}

#Preview {
    HealthKitPermissionPrimingView()
}
