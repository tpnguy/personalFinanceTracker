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