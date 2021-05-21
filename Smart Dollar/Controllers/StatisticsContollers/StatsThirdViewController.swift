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

    // Pie chart variable
    var barChart = BarChartView()
    
    // Variable for UD
    let defaults = UserDefaults.standard
    
    // Variables to store data lists
    var Transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLayoutSubviews()
        barChart.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
        fetchData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting up the frame for Bar Chart
        barChart.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        barChart.center = view.center
        
        // X-axis labeling
        var xAxis_label: [String]!
        xAxis_label = ["", "Income", "Expense", ""]
        
        // X-axis setup
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.axisMinimum = 0
        xaxis.axisMaximum = 3
        xaxis.granularity = 1
        barChart.fitBars = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: xAxis_label)
        
        // Y-axis/Left axis setup
        let yaxis = barChart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        // Right-axis setup
        barChart.rightAxis.axisMinimum = 0
        barChart.rightAxis.axisMaximum = 0
        
        view.addSubview(barChart)
        
//        fetchData();
    }
    
    func fetchData(){
        
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
            }
            if(Transactions[i].type == "Expense") {

                // Calculates total amount of Expense
                Expense_amount_total = Expense_amount_total + Transactions[i].amount!
            }
        }
        
        // Appends chart data enteries to display the values retrieved.
        entries.append(BarChartDataEntry(x: 1, y: Income_amount_total))
        entries.append(BarChartDataEntry(x: 2, y: Expense_amount_total))
//        entries.append(BarChartDataEntry()
        
        let set = BarChartDataSet(entries: entries, label: "")
        // Setting particular colors for each bar of the chart.
        set.colors = ChartColorTemplates.joyful();
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
}
