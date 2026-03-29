import Foundation

struct FinanceModel: Identifiable, Codable {
    let id: UUID
    let totalIncome: Double
    let totalExpenses: Double
    let expenseCategories: [String]
    let savingsForTheDay: Double
    let date: Date
    
    init(totalIncome: Double, totalExpenses: Double, expenseCategories: [String], savingsForTheDay: Double, date: Date) {
        self.id = UUID()
        self.totalIncome = totalIncome
        self.totalExpenses = totalExpenses
        self.expenseCategories = expenseCategories
        self.savingsForTheDay = savingsForTheDay
        self.date = date
    }
    
    init() {
        self.id = UUID()
        self.totalIncome = 0
        self.totalExpenses = 0
        self.expenseCategories = []
        self.savingsForTheDay = 0
        self.date = Date()
    }
}

let sampleFinanceData: [FinanceModel] = [
    FinanceModel(totalIncome: 210.00, totalExpenses: 39.80, expenseCategories: ["Groceries", "Coffee"], savingsForTheDay: 170.20, date: Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 200.00, totalExpenses: 58.32, expenseCategories: ["Groceries", "Coffee"], savingsForTheDay: 141.68, date: Calendar.current.date(byAdding: .day, value: -6, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 180.00, totalExpenses: 42.10, expenseCategories: ["Transportation", "Lunch"], savingsForTheDay: 137.90, date: Calendar.current.date(byAdding: .day, value: -5, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 180.00, totalExpenses: 85.50, expenseCategories: ["Groceries", "Entertainment"], savingsForTheDay: 94.50, date: Calendar.current.date(byAdding: .day, value: -4, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 220.00, totalExpenses: 25.99, expenseCategories: ["Coffee", "Transportation"], savingsForTheDay: 194.01, date: Calendar.current.date(byAdding: .day, value: -3, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 350.00, totalExpenses: 160.00, expenseCategories: ["Rent", "Utilities"], savingsForTheDay: 190.00, date: Calendar.current.date(byAdding: .day, value: -2, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 200.00, totalExpenses: 65.25, expenseCategories: ["Shopping", "Entertainment"], savingsForTheDay: 134.75, date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!),
    FinanceModel(totalIncome: 180.00, totalExpenses: 52.75, expenseCategories: ["Dining out", "Transportation"], savingsForTheDay: 127.25, date: Calendar.current.date(byAdding: .day, value: 0, to: Calendar.current.startOfDay(for: Date()))!),
]

extension Array where Element == FinanceModel {
    func financeDataLastSevenDays(relativeTo reference: Date = Date()) -> [FinanceModel] {
        let cal = Calendar.current
        let start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: reference))!
        let endExclusive = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: reference))!
        return filter { $0.date >= start && $0.date < endExclusive }
            .sorted { $0.date < $1.date }
    }
}
