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
    
    // Pie chart variable
    var pieChart = PieChartView()
    
    // Variable for UD
    let defaults = UserDefaults.standard
    
    // Variables to store data lists
    var Transactions: [Transaction] = []
    var values: [Double] = [];
    
    // Helper class initialisation
    let helper = Helper();

    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        
        // Append amount 0 to all the expenses
        for _ in helper.expenseCategories{
            values.append(0);
        }
        
//        fetchData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
        
        // Update amount to 0 for all the expenses
        for (i,_) in helper.expenseCategories.enumerated(){
            values[i] = 0;
        }
        
        fetchData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setting up the frame for Pie Chart
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        
        view.addSubview(pieChart)
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
        
        Transactions = Transactions.filter{ $0.type == "Expense"};
        
        for t in Transactions{
            for (i, val) in helper.expenseCategories.enumerated(){
                if(val == t.category){
                    values[i] = values[i] + t.amount!;
                }
            }
        }
        
        var entries = [ChartDataEntry]()
        
        for (i,_) in helper.expenseCategories.enumerated(){
            if(values[i] != 0){
                entries.append(PieChartDataEntry(value: values[i], label: helper.expenseCategories[i]))
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        
        // Setting particular colors for each bar of the chart.
        
        set.colors = ChartColorTemplates.joyful();
        set.valueColors = [UIColor.black]
        set.entryLabelColor = UIColor.black
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
    }
}
