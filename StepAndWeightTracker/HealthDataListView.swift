//
//  HealthDataListView.swift
//  StepAndWeightTracker
//
//  Created by Dariy Kutelov on 9.05.24.
//

import SwiftUI

struct HealthDataListView: View {
    @State private var isShowingAddData = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    let metric: HealthMetricContext
    
    var body: some View {
        List(0..<28) { i in
            HStack {
                Text(Date(), format: .dateTime.month(.wide).day().year())
                Spacer()
                Text(1000, format: .number.precision(.fractionLength(
                    metric == .steps ? 0 : 2)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker(
                    "Date",
                    selection: $addDataDate,
                    displayedComponents: .date
                )
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metric == .steps ?
                            .numberPad : .decimalPad)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //TODO: - add data
                        isShowingAddData = false
                    }
                    label: {
                        Text("Add Data")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingAddData = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
}
