//
//  Transaction.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import Foundation

struct Transaction: Codable {
    var amount: Double;
    var description: String;
    enum type: String {
        case income = "Income";
        case expense = "Expense";
    }
    var category: String;
    var date: Date;
}

