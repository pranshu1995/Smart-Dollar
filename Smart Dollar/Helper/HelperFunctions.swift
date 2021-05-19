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
    
    func showToast(message : String, view: UIView) {

    // Show toast notification if player exceeds high score



            let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height-150, width: 150, height: 35));

            toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6);

            toastLabel.textColor = UIColor.white;

            toastLabel.font = UIFont.systemFont(ofSize: 15.0);

            toastLabel.textAlignment = .center;

            toastLabel.text = message;

            toastLabel.alpha = 1.0;

            toastLabel.layer.cornerRadius = 10;

            toastLabel.clipsToBounds  =  true;

            view.addSubview(toastLabel);

            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {

                   toastLabel.alpha = 0.0;

               }, completion: {(isCompleted) in

                   toastLabel.removeFromSuperview();

               })

        }
    
    

    func deleteTransaction(id: String){
        var fetchedTransactions: [Transaction] = [];
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            print("deleting");
            for (index,transaction) in fetchedTransactions.enumerated(){
                if(transaction.id! == id){
                    fetchedTransactions.remove(at: index);
                    print("updated");
                    break;
                }
            }
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(fetchedTransactions), forKey: "Transactions");
            fetchedTransactions = [];
        }
    }

}
