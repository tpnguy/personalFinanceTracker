//
//  AllFinances.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/25/26.
//

import SwiftUI

struct AllFinances: View {
    var financeViewModel: FinanceViewModel

    private var sortedFinances: [FinanceModel] {
        financeViewModel.financeData.sorted { $0.date > $1.date }
    }

    var body: some View {
        Group {
            if sortedFinances.isEmpty {
                ContentUnavailableView(
                    "No transactions yet",
                    systemImage: "list.bullet.rectangle",
                    description: Text("Use Enter Financial Data on the home screen to add a record.")
                )
            } else {
                List {
                    ForEach(sortedFinances) { finance in
                        financeRow(finance)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("All Finances")
        .navigationBarTitleDisplayMode(.large)
    }

    private func financeRow(_ finance: FinanceModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(finance.date.formatted(date: .long, time: .omitted))
                .font(.headline)

            HStack(spacing: 12) {
                labelValue("Income", finance.totalIncome, color: .green)
                labelValue("Expenses", finance.totalExpenses, color: .red)
            }
            .font(.subheadline)

            HStack {
                Text("Net")
                    .foregroundStyle(.secondary)
                Text(finance.savingsForTheDay, format: .currency(code: "USD"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(finance.savingsForTheDay >= 0 ? Color.primary : Color.red)
            }

            if !finance.expenseCategories.isEmpty {
                Text(finance.expenseCategories.joined(separator: " · "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func labelValue(_ title: String, _ value: Double, color: Color) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .foregroundStyle(.secondary)
            Text(value, format: .currency(code: "USD"))
                .foregroundStyle(color)
        }
    }
}

#Preview {
    NavigationStack {
        AllFinances(financeViewModel: {
            let vm = FinanceViewModel()
            vm.financeData = sampleFinanceData
            return vm
        }())
    }
}
