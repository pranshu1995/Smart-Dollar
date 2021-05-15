//
//  BudgetViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 15/05/21.
//

import UIKit

class BudgetViewController: UIViewController {

    @IBOutlet weak var budgetLeftLabel: UILabel!
    @IBOutlet weak var budgetLevelBar: UIProgressView!
    @IBOutlet weak var budgetAmountInput: UITextField!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalBudgetLabel: UILabel!
    @IBOutlet weak var moneySpentLabel: UILabel!
    
    let helper = Helper();
    
    var budgetList: [Budget] = [];
    var currentMonth: String = "";
    var budgetValue: Double = 0;
    var budgetProgress: Float = 0;
    var currentIncome: Double = 0;
    var currentExpense: Double = 0;
    var balance: Double = 0;
    
    var fetchedTransactions: [Transaction] = [];
    var displayTransactions: [Transaction] = [];
    
//    var currentBudget: Budget = Budget(budgetValue: 0, monthYear: "", currency: "");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentMonth = helper.extractMonth(inDate: Date.init());
        calendarLabel.text = currentMonth;
        fetchData();
        getCurrentValues();
        getCurrentBudget();
        // Do any additional setup after loading the view.
    }
    
    @objc func fetchData(){
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            displayTransactions = fetchedTransactions.filter{ helper.extractMonth(inDate: $0.date) == currentMonth};
            print(displayTransactions);
        }
    }
    
    @objc func getCurrentValues(){
        for transaction in displayTransactions{
            if(transaction.type == "Income"){
                currentIncome = currentIncome + transaction.amount;
            }
            else if(transaction.type == "Expense"){
                currentExpense = currentExpense + transaction.amount;
            }
            
        }
        balance = currentIncome - currentExpense;
        print("income \(currentIncome)")
        print("expense \(currentExpense)")
    }
    
    @objc func getCurrentBudget(){
        
//        var currentBudget: Budget;
        
        if let data = UserDefaults.standard.value(forKey: "Budget") as? Data {
            budgetList = try! PropertyListDecoder().decode(Array<Budget>.self, from: data)
            print("currentwa \(budgetList)")
            for budget in budgetList{
                if(budget.monthYear == currentMonth){
                    print("pehle tha", budget);
                    budgetValue = budget.budgetValue;
                    totalBudgetLabel.text = String(budgetValue);
                    budgetProgress = Float((currentIncome - currentExpense)/budgetValue);
                    print(budgetProgress);
                    budgetLevelBar.setProgress(Float(budgetProgress), animated: true);
//                    budgetLeftLabel.text = String(budgetValue - balance);
                    
                }
            }
           
            
        }
    }
    

 
    @IBAction func budgetUpdate(_ sender: Any) {
        print("updating");
        
        let newBudget: Budget = Budget(budgetValue: Double(String(budgetAmountInput.text!))!, monthYear: currentMonth, currency: "AUD");
        
        if let data = UserDefaults.standard.value(forKey: "Budget") as? Data {
            budgetList = try! PropertyListDecoder().decode(Array<Budget>.self, from: data)
            print("kitta \(budgetList)")
            for (index,budget) in budgetList.enumerated(){
                if(budget.monthYear == currentMonth){
                    print("pehle tha", budget);
                    budgetList.remove(at: index);
                }
            }
        }
        
        budgetList.append(newBudget);
        print(budgetList);
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(budgetList), forKey: "Budget");
        getCurrentBudget();
    }
    
}
