//
//  HowAmIDoingView.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/28/26.
//

import SwiftUI

struct HowAmIDoingView: View {
    var financeViewModel: FinanceViewModel

    private var weekData: [FinanceModel] {
        financeViewModel.financeData.financeDataLastSevenDays()
    }

    private var cumulativeIncome: Double {
        weekData.reduce(0) { $0 + $1.totalIncome }
    }

    private var cumulativeExpenses: Double {
        weekData.reduce(0) { $0 + $1.totalExpenses }
    }

    private var cumulativeSavings: Double {
        weekData.reduce(0) { $0 + $1.savingsForTheDay }
    }

    private var averageDailyIncome: Double {
        cumulativeIncome / 7
    }

    private var averageDailyExpenses: Double {
        cumulativeExpenses / 7
    }

    private var averageDailySavings: Double {
        cumulativeSavings / 7
    }

    private var expenseRateOfIncome: Double {
        guard averageDailyIncome > 0 else { return 0 }
        return averageDailyExpenses / averageDailyIncome
    }

    private var savingsRateOfIncome: Double {
        guard averageDailyIncome > 0 else { return 0 }
        return averageDailySavings / averageDailyIncome
    }

    private var insight: (text: String, accent: Color) {
        guard !weekData.isEmpty, averageDailyIncome > 0 else {
            return ("Add financial entries for the last 7 days to see an insight.", .secondary)
        }

        if expenseRateOfIncome > 0.30 {
            return ("You are overspending!", .red)
        }
        if savingsRateOfIncome >= 0.10 && savingsRateOfIncome <= 0.30 {
            return ("You have a balanced budget!", .orange)
        }
        if savingsRateOfIncome > 0.30 {
            return ("You are saving well!", .green)
        }

        return ("Your average daily savings are below 10% of your income.", .secondary)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if weekData.isEmpty {
                    ContentUnavailableView(
                        "Not enough data",
                        systemImage: "chart.line.uptrend.xyaxis",
                        description: Text("Record income and expenses for the last 7 days to see insights.")
                    )
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last 7 days")
                            .font(.headline)
                        metricRow("Cumulative income", cumulativeIncome)
                        metricRow("Cumulative expenses", cumulativeExpenses)
                        metricRow("Cumulative savings", cumulativeSavings)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily averages")
                            .font(.headline)
                        metricRow("Average daily income", averageDailyIncome)
                        metricRow("Average daily expenses", averageDailyExpenses)
                        metricRow("Average daily savings", averageDailySavings)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Insight")
                            .font(.headline)
                        Text(insight.text)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(insight.accent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))

                    if averageDailyIncome > 0 {
                        Text("Compared to average daily income: expenses \(percentString(expenseRateOfIncome)) · savings \(percentString(savingsRateOfIncome))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("How am I doing?")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func metricRow(_ title: String, _ value: Double) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value, format: .currency(code: "USD"))
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }

    private func percentString(_ fraction: Double) -> String {
        (fraction * 100).formatted(.number.precision(.fractionLength(0)))
        + "%"
    }
}

#Preview {
    NavigationStack {
        HowAmIDoingView(financeViewModel: {
            let vm = FinanceViewModel()
            vm.financeData = sampleFinanceData
            return vm
        }())
    }
}
