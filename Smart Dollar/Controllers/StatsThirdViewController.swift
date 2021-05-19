//
//  StatsThirdViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//

import UIKit
import Charts

class StatsThirdViewController: UIViewController,ChartViewDelegate {

    var pieChart = PieChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
        
        print("Fetched Data for Charts:")
        
        if let data = defaults.value(forKey: "Transactions") as? Data {
            Transactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            Transactions.sort{
                $0.date > $1.date;
            }
//            print(Transactions);
        }
        
        let length = Transactions.count
        var entries = [ChartDataEntry]()
        
        for i in 0..<length {
            if(Transactions[i].type == "Income") {
//                print(Transactions[i])
                let x = Transactions[i].amount
                print(x)
                entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
            }
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel();
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
}
