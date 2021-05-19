//
//  StatsFirstViewController.swift
//  Smart Dollar
//
//  Created by Prashansa Nimbalkar on 19/05/21.
//

import UIKit
import Charts

class StatsFirstViewController: UIViewController, ChartViewDelegate {
    
    var barChart = BarChartView()
    let defaults = UserDefaults.standard
    var Transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
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
                $0.date! > $1.date!;
            }
            print(Transactions);
        }
        
        var entries = [BarChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful();
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
}
