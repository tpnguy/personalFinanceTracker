//
//  FinanceTrackerView.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/25/26.
//

import SwiftUI

struct FinanceTrackerView: View {
    @State private var financeViewModel: FinanceViewModel = {
        let vm = FinanceViewModel()
        vm.financeData = sampleFinanceData
        return vm
    }()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationLink {
                    WeekSummary(financeData: financeViewModel.financeData)
                } label: {
                    NavigationCard(title: "This week's summary", icon: "chart.bar.fill", color: .black)
                }
                .buttonStyle(.plain)
                .padding(20)
                LazyVGrid(columns: columns, spacing: 10) {
                    NavigationLink {
                        AllFinances(financeViewModel: financeViewModel)
                    } label: {
                        NavigationCard(title: "View All Finances", icon: "dollarsign.circle.fill", color: .green)
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        EnterFinancialData(financeViewModel: financeViewModel)
                    } label: {
                        NavigationCard(title: "Enter Financial Data", icon: "plus.circle.fill", color: .red)
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        HowAmIDoingView(financeViewModel: financeViewModel)
                    } label: {
                        NavigationCard(title: "How am I doing?", icon: "figure.walk.circle.fill", color: .yellow)
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        SettingsView(financeViewModel: financeViewModel)
                    } label: {
                        NavigationCard(title: "Settings", icon: "gear.circle.fill", color: .blue)
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
            }
            .navigationTitle("Finance Tracker")
        }
    }
}

#Preview {
    FinanceTrackerView()
}
