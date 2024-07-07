//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Vishnu Tejaa on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ExpenseTrackerViewModel()
    @State private var showingAddTransactionView = false
    @State private var showingThresholdSetting = false

    
    var body: some View {
        NavigationView {
            List {
                Text(viewModel.transactionsStatusMessage)
                Section(header: Text("Last 7 Days")) {
                    ForEach(viewModel.transactionsForLastSevenDays()) { transaction in
                        VStack(alignment: .leading) {
                            Text(transaction.description)
                            Text("$\(transaction.amount, specifier: "%.2f")")
                                .font(.subheadline)
                            Text(transaction.date, style: .date)
                        }
                    }
                }
                
                Section {
                    Text(viewModel.spendingHabitAnalysis())
                        .font(.headline)
                }
                let dayOfWeekFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "E" 
                    return formatter
                }()

                Section(header: Text("Weekly Summary")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom) {
                            ForEach(viewModel.transactionsForLastSevenDays(), id: \.id) { transaction in
                                VStack {
                                    Rectangle()
                                        .fill(transaction.category == .spending ? Color.red : Color.green)
                                        .frame(width: 20, height: CGFloat(transaction.amount) / 4) // Example scaling
                                    // Display the day of the week for each transaction
                                    Text(transaction.date, formatter: dayOfWeekFormatter)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }

            }
            .navigationTitle("My Activities")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    showingAddTransactionView = true
                }) {
                    Image(systemName: "plus")
                }
                
                Button(action: {
                        showingThresholdSetting = true
                    }) {Text("Set Threshold")
//                        Image(systemName: "slider.horizontal.2")
                    }
                
            })
            .sheet(isPresented: $showingAddTransactionView) {
                // Assuming AddTransactionView exists for adding transactions
                AddTransactionView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingThresholdSetting) {
                            Text("Enter the Threshold amount")
                    .padding().font(.title3).bold()
                            ThresholdSettingView(threshold: $viewModel.threshold)
                        }
        }
    }
}
struct ThresholdSettingView: View {
    @Binding var threshold: Double
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Set New Threshold", value: $threshold, format: .number)
                    .keyboardType(.decimalPad)
                    .padding()
            }
            .navigationBarTitle(Text("Threshold"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ExpenseTrackerViewModel())
    }
}




