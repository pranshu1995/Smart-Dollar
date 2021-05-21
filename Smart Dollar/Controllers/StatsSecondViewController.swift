//
//  StatsSecondViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//
// File created for showcasing Pie Chart of Income category vise.

import UIKit
import Charts

class StatsSecondViewController: UIViewController,ChartViewDelegate  {
    
    var pieChart = PieChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
        fetchData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting up the frame for Pie Chart
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        fetchData()
        
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
        var entries = [ChartDataEntry]()
        
        var deposits_Amount = 0.0
        var salary_Amount = 0.0
        var savings_Amount = 0.0
        
        
        for i in 0..<length {
            
            // Condition to filter "Income" Transactions
            if(Transactions[i].type == "Income") {
                
                // Condition to filter "Deposit" category in "Income" Transactions
                if(Transactions[i].category == "Deposits") {
                    deposits_Amount = deposits_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Salary" category in "Income" Transactions
                else if(Transactions[i].category == "Salary") {
                    salary_Amount = salary_Amount +  Transactions[i].amount!
                }
                
                // Condition to filter "Savings" category in "Income" Transactions
                else if(Transactions[i].category == "Savings") {
                    savings_Amount = savings_Amount +  Transactions[i].amount!
                }
            }
        }
        
        
        if (deposits_Amount == 0.0) {
            entries.append(ChartDataEntry(x: 1, y: 0))
        }
        else {
            // Appends chart data enteries to display the values retrieved if not 0.
            entries.append(ChartDataEntry(x: 1, y: Double(deposits_Amount)))
        }

        if (salary_Amount == 0.0) {
            entries.append(ChartDataEntry(x: 2, y: 0.0))
        }
        else {
            // Appends chart data enteries to display the values retrieved if not 0.
            entries.append(ChartDataEntry(x: 2, y: Double(salary_Amount)))
        }

        if (savings_Amount == 0.0) {
            entries.append(ChartDataEntry(x: 3, y: 0.0))
        }
        else {
            // Appends chart data enteries to display the values retrieved if not 0.
            entries.append(ChartDataEntry(x: 3, y: Double(savings_Amount)))
        }
        
        let set = PieChartDataSet(entries: entries)
        // Setting particular colors for each bar of the chart.
        set.colors = [UIColor.systemRed,UIColor.systemTeal,UIColor.systemYellow]
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
}
