//
//  SettingsView.swift
//  personalFinanceTracker
//
//  Created by Thienban Nguyen on 3/28/26.
//

import SwiftUI

struct SettingsView: View {
    var financeViewModel: FinanceViewModel

    @State private var confirmClear = false

    private var recordCount: Int {
        financeViewModel.financeData.count
    }

    var body: some View {
        Form {
            Section {
                LabeledContent("Saved records") {
                    Text("\(recordCount)")
                        .foregroundStyle(.secondary)
                }

                Button("Clear all financial data", role: .destructive) {
                    confirmClear = true
                }
                .disabled(recordCount == 0)
            } footer: {
                Text("Removes every transaction from this device. Summaries and lists will be empty until you add new entries.")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Clear all financial data?", isPresented: $confirmClear, titleVisibility: .visible) {
            Button("Clear all", role: .destructive) {
                financeViewModel.clearAllFinanceData()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all \(recordCount) record\(recordCount == 1 ? "" : "s"). This cannot be undone.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(financeViewModel: {
            let vm = FinanceViewModel()
            vm.financeData = sampleFinanceData
            return vm
        }())
    }
}
