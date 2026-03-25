//
//  FinanceTrackerView.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/25/26.
//

import SwiftUI

struct FinanceTrackerView: View {
    private var financeViewModel = FinanceViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationCard(title:"This week's summary", icon: "chart.bar.fill", color: .black)
                    .padding(20)
                LazyVGrid(columns: columns, spacing: 10) {
                    NavigationCard(title: "View All Finances", icon: "dollarsign.circle", color: .green)
                    NavigationCard(title: "Add New Finance Data", icon: "plus.circle", color: .red)
                    NavigationCard(title: "Settings", icon: "gearshape", color: .blue)
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
