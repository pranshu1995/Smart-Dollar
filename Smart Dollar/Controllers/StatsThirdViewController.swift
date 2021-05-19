//
//  StatsThirdViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//

import UIKit
import Charts

class StatsThirdViewController: UIViewController,ChartViewDelegate {

    var barChart = BarChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        
        view.addSubview(barChart)
        
        print("Fetched Data for Charts:")
        
        if let data = defaults.value(forKey: "Transactions") as? Data {
            Transactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            Transactions.sort{
                $0.date! < $1.date!;
            }
            print(Transactions);
        }
        
        let length = Transactions.count
        var entries = [BarChartDataEntry]()
        var Income_amount_total = 0.0
        var Expense_amount_total = 0.0
        
        for i in 0..<length {
            if(Transactions[i].type == "Income") {
//                print(Transactions[i])
                Income_amount_total = Income_amount_total + Transactions[i].amount!
                print(Income_amount_total)
            }
            if(Transactions[i].type == "Expense") {
//                print(Transactions[i])
                Expense_amount_total = Expense_amount_total + Transactions[i].amount!
                print(Expense_amount_total)
            }
        }
        
        entries.append(BarChartDataEntry(x: 1.0, y: Income_amount_total))
        entries.append(BarChartDataEntry(x: 2.0, y: Expense_amount_total))
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful();
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
}
