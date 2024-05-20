//
//  ContentView.swift
//  StepAndWeightTracker
//
//  Created by Dariy Kutelov on 8.05.24.
//

import SwiftUI

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {
    @AppStorage("hasSeenPermissingPriming") private var hasSeenPermissingPriming = false
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingPermissionPrimingScreen = false
    @State private var selectadStat: HealthMetricContext = .steps
    
    var isSteps: Bool {
        selectadStat == .steps
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("SelectedStat", selection: $selectadStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    VStack {
                        NavigationLink(value: selectadStat){
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps",
                                          systemImage: "figure.walk")
                                    .font(.title3.bold())
                                    .foregroundStyle(.pink)
                                    Text("Avg: 10k steps")
                                        .font(.caption)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)

                        RoundedRectangle(cornerRadius: 12.0)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Label("Averages",
                                  systemImage: "calendar")
                            .font(.title3.bold())
                            .foregroundStyle(.pink)
                            Text("Last 28 Days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 12.0)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .padding()
            }
            .padding()
            .task {
                isShowingPermissionPrimingScreen = !hasSeenPermissingPriming
                
                // add sample data
                // await hkManager.addSimulatorData()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(isPresented: $isShowingPermissionPrimingScreen) {
                //
            } content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissingPriming)
            }

        }
        .tint(isSteps ? .pink : .indigo) // color of the back button on next view
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
