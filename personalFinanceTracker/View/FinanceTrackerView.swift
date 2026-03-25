//
//  FinanceTrackerView.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/25/26.
//

import SwiftUI

struct FinanceTrackerView: View {
    private var financeViewModel = FinanceViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text(financeViewModel.showLastWeekSummary())
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding()
                .navigationTitle("Finance Tracker")
            }
        }
    }
}

#Preview {
    FinanceTrackerView()
}
