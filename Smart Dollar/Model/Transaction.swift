//
//  Transaction.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import Foundation

struct Transaction: Codable {
    var id: String;
    var amount: Double;
    var description: String;
    var type: String;
    var category: String;
    var date: Date;
    var currency: String;
}

// Filter Homepage
// Transaction last click issue
// Handle negative balance in budget
// Budget page what to display
