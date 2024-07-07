//
//  TransactionViewModel.swift
//  ExpenseTracker
//
//  Created by Vishnu Tejaa on 3/1/24.
//

import Foundation
import Combine

import Foundation
import Combine

class ExpenseTrackerViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var threshold: Double = 100.0 // Example threshold setting
    
    // Initialize with some data for preview purposes
//    init() {
//        // Starting with one sample transaction for demonstration. Comment or uncomment to test.
//        let sampleTransactions = [
//            Transaction(description: "Groceries", amount: 50, date: Date().addingTimeInterval(-86400), category: .spending),
//            // Comment or uncomment the following lines to simulate empty or populated transactions list
//            //Transaction(description: "Salary", amount: 1500, date: Date().addingTimeInterval(-2*86400), category: .savings),
//            //Transaction(description: "Coffee", amount: 5, date: Date().addingTimeInterval(-3*86400), category: .spending)
//        ]
//        self.transactions = sampleTransactions
//    }
    
    func addTransaction(description: String, amount: Double, date: Date, category: TransactionCategory) {
        let newTransaction = Transaction(description: description, amount: amount, date: date, category: category)
        DispatchQueue.main.async {
            self.transactions.append(newTransaction)
        }
    }
    
    func transactionsForLastSevenDays() -> [Transaction] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return transactions.filter { $0.date >= oneWeekAgo }
    }
    
    func spendingHabitAnalysis() -> String {
        let weeklyTransactions = transactionsForLastSevenDays()
        let totalSpent = weeklyTransactions.filter { $0.category == .spending }.reduce(0) { $0 + $1.amount }
        let totalSaved = weeklyTransactions.filter { $0.category == .savings }.reduce(0) { $0 + $1.amount }
        let net = totalSaved - totalSpent
        
        if net < 0 && totalSpent > threshold {
            return "You spent too much!"
        } else if net > 0 && totalSaved > threshold {
            return "You save some good money!"
        } else if abs(net)<threshold && !(net==0.00) {
            return "You have a normal budget now!"
        }
        else{
            return "You don't have a budget yet!"
        }
    }
    
    // Computed property to check if the transactions list is empty
    var transactionsStatusMessage: String {
        if transactions.isEmpty {
            return "No transactions recorded yet."
        } else {
            return "Transactions recorded. See below for details."
        }
    }
}




