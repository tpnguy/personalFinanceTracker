//
//  WeekSummary.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/28/26.
//

import Charts
import SwiftUI

struct WeekSummary: View {
    let financeData: [FinanceModel]

    private var calendar: Calendar { Calendar.current }

    private var weekData: [FinanceModel] {
        financeData.financeDataLastSevenDays()
    }

    private var periodLabel: String {
        let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: Date()))!
        let end = calendar.startOfDay(for: Date())
        return "\(start.formatted(date: .abbreviated, time: .omitted)) – \(end.formatted(date: .abbreviated, time: .omitted))"
    }

    private var totalIncome: Double {
        weekData.reduce(0) { $0 + $1.totalIncome }
    }

    private var totalExpenses: Double {
        weekData.reduce(0) { $0 + $1.totalExpenses }
    }

    private var netSavings: Double {
        weekData.reduce(0) { $0 + $1.savingsForTheDay }
    }

    private var weekStackedRows: [WeekStackedRow] {
        weekData.map(WeekStackedRow.init(_:))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                weekHeader
                if weekData.isEmpty {
                    emptyState
                } else {
                    weekContent
                }
            }
            .padding()
        }
        .navigationTitle("Week summary")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var weekHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Last 7 days")
                .font(.title2.weight(.semibold))
            Text(periodLabel)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No data this week",
            systemImage: "chart.bar.xaxis",
            description: Text("Add finances for the past week to see a summary and chart.")
        )
        .frame(maxWidth: .infinity, minHeight: 220)
    }

    private var weekContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            metricsRow
            WeekStackedBarChart(rows: weekStackedRows)
            dailyBreakdown
        }
    }

    private var metricsRow: some View {
        HStack(spacing: 12) {
            summaryMetricCard(
                title: "Income",
                value: totalIncome,
                icon: "arrow.down.circle.fill",
                tint: .green
            )
            summaryMetricCard(
                title: "Expenses",
                value: totalExpenses,
                icon: "arrow.up.circle.fill",
                tint: .red
            )
            summaryMetricCard(
                title: "Net saved",
                value: netSavings,
                icon: "banknote.fill",
                tint: .blue
            )
        }
    }

    private var dailyBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily breakdown")
                .font(.headline)
            ForEach(weekData) { day in
                dayRow(day)
            }
        }
    }

    private func summaryMetricCard(title: String, value: Double, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)
            Text(value, format: .currency(code: "USD"))
                .font(.subheadline.weight(.semibold))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func dayRow(_ day: FinanceModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(day.savingsForTheDay, format: .currency(code: "USD"))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(day.savingsForTheDay >= 0 ? Color.primary : Color.red)
            }
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                    Text(day.totalIncome, format: .currency(code: "USD"))
                }
                .font(.caption)
                .foregroundStyle(.green)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                    Text(day.totalExpenses, format: .currency(code: "USD"))
                }
                .font(.caption)
                .foregroundStyle(.red)
            }
            if !day.expenseCategories.isEmpty {
                Text(day.expenseCategories.joined(separator: " · "))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct WeekStackedBarChart: View {
    let rows: [WeekStackedRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Income and spending")
                .font(.headline)
                .foregroundStyle(.secondary)

            chart
                .frame(height: 260)
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var chart: some View {
        Chart {
            ForEach(rows) { row in
                stackedMarks(for: row)
            }
        }
        .chartForegroundStyleScale([
            "Kept": Color.green,
            "Spent": Color.red,
            "Over income": Color.orange,
        ])
        .chartLegend(position: .bottom, alignment: .center)
        .chartXAxis { weekChartXAxis }
        .chartYAxis { weekChartYAxis }
    }

    @ChartContentBuilder
    private func stackedMarks(for row: WeekStackedRow) -> some ChartContent {
        BarMark(
            x: .value("Day", row.date, unit: .day),
            yStart: .value("Stack", row.keptStart),
            yEnd: .value("Stack", row.keptEnd)
        )
        .foregroundStyle(by: .value("Segment", "Kept"))
        BarMark(
            x: .value("Day", row.date, unit: .day),
            yStart: .value("Stack", row.spentStart),
            yEnd: .value("Stack", row.spentEnd)
        )
        .foregroundStyle(by: .value("Segment", "Spent"))
        BarMark(
            x: .value("Day", row.date, unit: .day),
            yStart: .value("Stack", row.overStart),
            yEnd: .value("Stack", row.overEnd)
        )
        .foregroundStyle(by: .value("Segment", "Over income"))
    }

    private var weekChartXAxis: some AxisContent {
        AxisMarks(values: .stride(by: .day)) { value in
            AxisGridLine()
            AxisValueLabel {
                if let date = value.as(Date.self) {
                    Text(date, format: .dateTime.weekday(.narrow))
                }
            }
        }
    }

    private var weekChartYAxis: some AxisContent {
        AxisMarks(position: .leading) { value in
            AxisGridLine()
            AxisValueLabel {
                if let amount = value.as(Double.self) {
                    Text(amount, format: .currency(code: "USD").precision(.fractionLength(0)))
                }
            }
        }
    }
}

/// Stacked bar from a single day’s income: green [0, kept], red [kept, kept+spentFromIncome], orange above income if needed.
struct WeekStackedRow: Identifiable {
    let id: UUID
    let date: Date
    let keptStart: Double
    let keptEnd: Double
    let spentStart: Double
    let spentEnd: Double
    let overStart: Double
    let overEnd: Double

    init(_ day: FinanceModel) {
        id = day.id
        date = day.date
        let income = day.totalIncome
        let expenses = day.totalExpenses
        let kept = max(0, income - expenses)
        let spentFromIncome = min(expenses, income)
        let overIncome = max(0, expenses - income)

        keptStart = 0
        keptEnd = kept
        spentStart = kept
        spentEnd = kept + spentFromIncome
        overStart = kept + spentFromIncome
        overEnd = kept + spentFromIncome + overIncome
    }
}

#Preview {
    NavigationStack {
        WeekSummary(financeData: sampleFinanceData)
    }
}
