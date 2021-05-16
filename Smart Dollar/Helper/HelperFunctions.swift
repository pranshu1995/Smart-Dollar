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
    dateFormatterGet.dateFormat = "MMM yyyy";
    let returnDate: String = dateFormatterGet.string(from: inDate);
    return returnDate;
    }
    
    func extractDate(inDate: Date) -> String{
    let dateFormatterGet = DateFormatter();
    dateFormatterGet.dateFormat = "dd";
    let returnDate: String = dateFormatterGet.string(from: inDate);
    return returnDate;
    }
    
    func getMonths() -> [String]{
        var monthArr: [String] = [];
        
        for i in -4...4{
            let value = extractMonth(inDate: Calendar.current.date(byAdding: .month, value: i, to: Date())!);
            print(value);
            monthArr.append(value);
        }
        
        return monthArr;
    }
    func monthDaysLeft() -> String{
        let calendar = Calendar.current
        let date = Date.init()

        // Calculate start and end of the current year (or month with `.month`):
        let interval = calendar.dateInterval(of: .month, for: date)! //change year it will no of days in a year , change it to month it will give no of days in a current month

        // Compute difference in days:
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        print(days)
        print(self.extractDate(inDate: date));
        
        let daysLeft = Int(days) - Int(self.extractDate(inDate: date))!;
        print(daysLeft);
        
        return String(daysLeft);
        
    }
}
