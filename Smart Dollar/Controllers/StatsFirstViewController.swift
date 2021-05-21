//
//  StatsFirstViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//
// File created for showcasing Pie Chart of Expense category vise.

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
        
        // Setting up the frame for Pie Chart
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        // Condition to fetch the Transactions data from UserDefaults and sort it in the order of oldest to newest.
        if let data = defaults.value(forKey: "Transactions") as? Data {
            Transactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            Transactions.sort{
                $0.date! < $1.date!;
            }
        }
        
        // To calculate the number of Transactions
        let length = Transactions.count
        
        // To store chart data entries
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
            
            // Condition to filter "Expense" Transactions
            if(Transactions[i].type == "Expense") {
                
                // Condition to filter "Shopping" category in "Expense" Transactions
                if(Transactions[i].category == "Shopping") {
                    shopping_Amount = shopping_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Restaurant" category in "Expense" Transactions
                else if(Transactions[i].category == "Restaurant") {
                    restaurant_Amount = restaurant_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Grocery" category in "Expense" Transactions
                else if(Transactions[i].category == "Grocery") {
                    grocery_Amount = grocery_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Housing" category in "Expense" Transactions
                else if(Transactions[i].category == "Housing") {
                    housing_Amount = housing_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Transportation" category in "Expense" Transactions
                else if(Transactions[i].category == "Transportation") {
                    transportation_Amount = transportation_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Vehicle" category in "Expense" Transactions
                else if(Transactions[i].category == "Vehicle") {
                    vehicle_Amount = vehicle_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Entertainment" category in "Expense" Transactions
                else if(Transactions[i].category == "Entertainment") {
                    entertainment_Amount = entertainment_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Communication" category in "Expense" Transactions
                else if(Transactions[i].category == "Communication") {
                    communication_Amount = communication_Amount +  Transactions[i].amount!
                }
            }
        }
        
        // Appends chart data enteries to display the values retrieved.
        entries.append(ChartDataEntry(x: 1, y: Double(shopping_Amount)))
        entries.append(ChartDataEntry(x: 2, y: Double(restaurant_Amount)))
        entries.append(ChartDataEntry(x: 3, y: Double(grocery_Amount)))
        entries.append(ChartDataEntry(x: 4, y: Double(housing_Amount)))
        entries.append(ChartDataEntry(x: 5, y: Double(transportation_Amount)))
        entries.append(ChartDataEntry(x: 6, y: Double(vehicle_Amount)))
        entries.append(ChartDataEntry(x: 7, y: Double(entertainment_Amount)))
        entries.append(ChartDataEntry(x: 8, y: Double(communication_Amount)))
        
        let set = PieChartDataSet(entries: entries)
        
        // Setting particular colors for each bar of the chart.
        set.colors = [UIColor.systemRed,UIColor.systemOrange,UIColor.systemTeal,UIColor.systemPink,UIColor.systemIndigo,UIColor.systemYellow,UIColor.systemPurple,UIColor.systemGreen]
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        

    }
}
