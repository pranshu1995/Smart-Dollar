//
//  StatsThirdViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//
// File created for showcasing Bar Graph of Income and Expense together.

import UIKit
import Charts

class StatsThirdViewController: UIViewController,ChartViewDelegate {

    var barChart = BarChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLayoutSubviews()
        barChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting up the frame for Bar Chart
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        
        view.addSubview(barChart)
        
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
        var entries = [BarChartDataEntry]()
        
        var Income_amount_total = 0.0
        var Expense_amount_total = 0.0
        
        for i in 0..<length {
            if(Transactions[i].type == "Income") {
                
                // Calculates total amount of Income
                Income_amount_total = Income_amount_total + Transactions[i].amount!
                print(Income_amount_total)
            }
            if(Transactions[i].type == "Expense") {

                // Calculates total amount of Expense
                Expense_amount_total = Expense_amount_total + Transactions[i].amount!
                print(Expense_amount_total)
            }
        }
        
        // Appends chart data enteries to display the values retrieved.
        entries.append(BarChartDataEntry(x: 1, y: Income_amount_total))
        entries.append(BarChartDataEntry(x: 2, y: Expense_amount_total))
        
        let set = BarChartDataSet(entries: entries)
        // Setting particular colors for each bar of the chart.
        set.colors = [UIColor.systemPink,UIColor.systemOrange]
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
}
