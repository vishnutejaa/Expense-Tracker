//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by Vishnu Tejaa on 3/1/24.
//

import Foundation

// Transaction model
struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let amount: Double
    let date: Date
    let category: TransactionCategory
}

enum TransactionCategory {
    case spending, savings
}

