//
//  StatsSecondViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//

import UIKit
import Charts

class StatsSecondViewController: UIViewController,ChartViewDelegate  {
    
    var lineChart = LineChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        lineChart.center = view.center
        
        view.addSubview(lineChart)
        
        print("Fetched Data for Charts:")
        
        print("Fetched Data for Charts:")
        
        if let data = defaults.value(forKey: "Transactions") as? Data {
            Transactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            Transactions.sort{
                $0.date! > $1.date!;
            }
//            print(Transactions);
        }
        
        let length = Transactions.count
        var entries = [ChartDataEntry]()
        
        for i in 0..<length {
            if(Transactions[i].type == "Income") {
//                print(Transactions[i])
                let x = Transactions[i].amount
                print(x!)
                entries.append(ChartDataEntry(x: Double(i), y: Double(x!)))
            }
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material();
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
}
