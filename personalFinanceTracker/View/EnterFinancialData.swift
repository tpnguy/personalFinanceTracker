//
//  EnterFinancialData.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/28/26.
//

import SwiftUI

struct EnterFinancialData: View {
    var financeViewModel: FinanceViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var totalIncome: Double = 0
    @State private var totalExpenses: Double = 0
    @State private var categoriesText = ""

    private var savingsForTheDay: Double {
        totalIncome - totalExpenses
    }

    private var parsedCategories: [String] {
        categoriesText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        Form {
            Section("Date") {
                DatePicker("Day", selection: $date, displayedComponents: .date)
            }

            Section("Amounts") {
                TextField("Total income", value: $totalIncome, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                TextField("Total expenses", value: $totalExpenses, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                LabeledContent("Savings for the day") {
                    Text(savingsForTheDay, format: .currency(code: "USD"))
                        .foregroundStyle(savingsForTheDay >= 0 ? Color.primary : Color.red)
                }
            }

            Section {
                TextField("Categories (comma-separated)", text: $categoriesText, axis: .vertical)
                    .lineLimit(3...6)
            } header: {
                Text("Expense categories")
            } footer: {
                Text("Examples: Groceries, Transportation, Rent")
                    .font(.caption)
            }
        }
        .navigationTitle("Enter financial data")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveEntry()
                }
            }
        }
    }

    private func saveEntry() {
        let dayStart = Calendar.current.startOfDay(for: date)
        let entry = FinanceModel(
            totalIncome: totalIncome,
            totalExpenses: totalExpenses,
            expenseCategories: parsedCategories,
            savingsForTheDay: savingsForTheDay,
            date: dayStart
        )
        financeViewModel.addFinanceData(financeData: entry)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EnterFinancialData(financeViewModel: FinanceViewModel())
    }
}
