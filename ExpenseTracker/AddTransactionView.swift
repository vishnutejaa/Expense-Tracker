//
//  AddTransactionView.swift
//  ExpenseTracker
//
//  Created by Vishnu Tejaa on 3/1/24.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: ExpenseTrackerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var description: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var category: TransactionCategory = .spending
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Description", text: $description)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Picker("Category", selection: $category) {
                        Text("Spending").tag(TransactionCategory.spending)
                        Text("Savings").tag(TransactionCategory.savings)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button("Save") {
                        if let amountDouble = Double(amount) {
                            viewModel.addTransaction(description: description, amount: amountDouble, date: date, category: category)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(description.isEmpty || amount.isEmpty)
                }
                
                
            }
            .navigationBarTitle("Add Transaction", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(viewModel: ExpenseTrackerViewModel())
    }
}
