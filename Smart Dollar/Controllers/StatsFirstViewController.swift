//
//  StatsFirstViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//

import UIKit
import Charts

class StatsFirstViewController: UIViewController, ChartViewDelegate {
    
    var pieChart = PieChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        if let data = defaults.value(forKey: "Transactions") as? Data {
            Transactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            Transactions.sort{
                $0.date! < $1.date!;
            }
        }
        
        let length = Transactions.count
        var entries = [ChartDataEntry]()
        var shopping_Amount = 0.0
        var restaurant_Amount = 0.0
        var grocery_Amount = 0.0
        var housing_Amount = 0.0
        var transportation_Amount = 0.0
        var vehicle_Amount = 0.0
        var entertainment_Amount = 0.0
        var communication_Amount = 0.0
        
        
        for i in 0..<length {
            if(Transactions[i].type == "Expense") {
                if(Transactions[i].category == "Shopping") {
                    shopping_Amount = shopping_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Restaurant") {
                    restaurant_Amount = restaurant_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Grocery") {
                    grocery_Amount = grocery_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Housing") {
                    housing_Amount = housing_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Transportation") {
                    transportation_Amount = transportation_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Vehicle") {
                    vehicle_Amount = vehicle_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Entertainment") {
                    entertainment_Amount = entertainment_Amount +  Transactions[i].amount!
                }
                else if(Transactions[i].category == "Communication") {
                    communication_Amount = communication_Amount +  Transactions[i].amount!
                }
            }
        }
        
        print("S", shopping_Amount)
        entries.append(ChartDataEntry(x: 1, y: Double(shopping_Amount)))
        print("R", restaurant_Amount)
        entries.append(ChartDataEntry(x: 2, y: Double(restaurant_Amount)))
        print("G", grocery_Amount)
        entries.append(ChartDataEntry(x: 3, y: Double(grocery_Amount)))
        print("H", housing_Amount)
        entries.append(ChartDataEntry(x: 4, y: Double(housing_Amount)))
        print("T", transportation_Amount)
        entries.append(ChartDataEntry(x: 5, y: Double(transportation_Amount)))
        print("V", vehicle_Amount)
        entries.append(ChartDataEntry(x: 6, y: Double(vehicle_Amount)))
        print("E", entertainment_Amount)
        entries.append(ChartDataEntry(x: 7, y: Double(entertainment_Amount)))
        print("C", communication_Amount)
        entries.append(ChartDataEntry(x: 8, y: Double(communication_Amount)))
        
//entries.append(ChartDataEntry(x: Double(i), y: Double(x!))))))
        
        let set = PieChartDataSet(entries: entries)
        set.colors = [UIColor.systemRed,UIColor.systemOrange,UIColor.systemTeal,UIColor.systemPink,UIColor.systemIndigo,UIColor.systemYellow,UIColor.systemPurple,UIColor.systemGreen]
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        

    }
}
