//
//  HelperFunctions.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 14/05/21.
//

import Foundation
import UIKit

struct Helper{
    
    func dateToString(inDate: Date) -> String{
        // Convert date to a Readable format for the user
        let dateFormatterGet = DateFormatter();
        dateFormatterGet.dateFormat = "MMM dd, yyyy HH:mm";
        let returnDate: String = dateFormatterGet.string(from: inDate);
        return returnDate;
    }
    
    func extractMonth(inDate: Date) -> String{
        // Extract month and year string from the current date
        let dateFormatterGet = DateFormatter();
        dateFormatterGet.dateFormat = "MMM yyyy";
        let returnDate: String = dateFormatterGet.string(from: inDate);
        return returnDate;
    }
    
    func extractDate(inDate: Date) -> String{
        // Extract date value string from the current date
        let dateFormatterGet = DateFormatter();
        dateFormatterGet.dateFormat = "dd";
        let returnDate: String = dateFormatterGet.string(from: inDate);
        return returnDate;
    }
    
    func getMonths() -> [String]{
        // Extract 4 months before and after the current month
        var monthArr: [String] = [];
        for i in -4...4{
            let value = extractMonth(inDate: Calendar.current.date(byAdding: .month, value: i, to: Date())!);
            monthArr.append(value);
        }
        return monthArr;
    }
    
    func monthDaysLeft() -> String{
        // Calculate the number of day left in the month
        let calendar = Calendar.current
        let date = Date.init()
        let interval = calendar.dateInterval(of: .month, for: date)!
        let days = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        let daysLeft = Int(days) - Int(self.extractDate(inDate: date))!;
        return String(daysLeft);
        
    }
    
    func showToast(message : String, view: UIView, type : String) {
            let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height-150, width: 150, height: 35));

            toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6);
            
            if(type == "Error"){
                toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6);
            }
            else if(type == "Success"){
                toastLabel.backgroundColor = UIColor.green.withAlphaComponent(0.6);
            }
            toastLabel.textColor = UIColor.white;
            toastLabel.font = UIFont.systemFont(ofSize: 15.0);
            toastLabel.textAlignment = .center;
            toastLabel.text = message;
            toastLabel.alpha = 1.0;
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true;
            view.addSubview(toastLabel);

        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                   toastLabel.alpha = 0.0;
               }, completion: {(isCompleted) in
                   toastLabel.removeFromSuperview();
               })
        }
    

    func deleteTransaction(id: String){
        // Delete a transaction from the UserDefaults
        var fetchedTransactions: [Transaction] = [];
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data);
            for (index,transaction) in fetchedTransactions.enumerated(){
                if(transaction.id! == id){
                    fetchedTransactions.remove(at: index);
                    break;
                }
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(fetchedTransactions), forKey: "Transactions");
            fetchedTransactions = [];
        }
    }
}
