//
//  HelperFunctions.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 14/05/21.
//

import Foundation

struct Helper{
    
    func dateToString(inDate: Date) -> String{
        let dateFormatterGet = DateFormatter();
        dateFormatterGet.dateFormat = "MMM dd, yyyy HH:mm";
        let returnDate: String = dateFormatterGet.string(from: inDate);
        return returnDate;
    }
    
    func extractMonth(inDate: Date) -> String{
    let dateFormatterGet = DateFormatter();
    dateFormatterGet.dateFormat = "MMM";
    let returnDate: String = dateFormatterGet.string(from: inDate);
    return returnDate;
    }
}
