import Observation
import Foundation
import Combine

@Observable
class FinanceViewModel {
    var financeData: [FinanceModel] = []
    func addFinanceData(financeData: FinanceModel) {
        self.financeData.append(financeData)
    }

    func clearAllFinanceData() {
        financeData.removeAll()
    }
    func showLastWeekSummary() -> String {
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let lastWeekFinanceData = financeData.filter { $0.date >= lastWeek && $0.date < Date() }
        let totalIncome = lastWeekFinanceData.reduce(0) { $0 + $1.totalIncome }
        let totalExpenses = lastWeekFinanceData.reduce(0) { $0 + $1.totalExpenses }
        return "Total Income: \(totalIncome), Total Expenses: \(totalExpenses)"
    }
    func totalIncome() -> Double {
        return financeData.last?.totalIncome ?? 0
    }
    func totalExpenses() -> Double {
        return financeData.last?.totalExpenses ?? 0
    }
    func savingsForTheDay() -> Double {
        return financeData.last?.savingsForTheDay ?? 0
    }
    func date() -> Date {
        return financeData.last?.date ?? Date()
    }
    func expenseCategories() -> [String] {
        return financeData.last?.expenseCategories ?? []
    }
}
