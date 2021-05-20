//
//  BudgetViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 15/05/21.
//

import UIKit

class BudgetViewController: UIViewController {
    // Page for Budget control

    // Outlet variable for page
    @IBOutlet weak var budgetLeftLabel: UILabel!
    @IBOutlet weak var budgetLevelBar: UIProgressView!
    @IBOutlet weak var budgetAmountInput: UITextField!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var totalBudgetLabel: UILabel!

    // Variable for data values
    var currentMonth: String = "";
    var budgetValue: Double = 0;
    var budgetProgress: Float = 0;
    var currentIncome: Double = 0;
    var currentExpense: Double = 0;
    var balance: Double = 0;
    var currencyValue: String = "AUD";
    
    // Variables to store data lists
    var budgetList: [Budget] = [];
    var fetchedTransactions: [Transaction] = [];
    var displayTransactions: [Transaction] = [];
    
    // Helper class initialisation
    let helper = Helper();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentMonth();
        fetchData();
        getCurrentValues();
        getCurrentBudget();
        // Do any additional setup after loading the view.
    }
    
    @objc func setCurrentMonth(){
        // Update values to current month
        
        currentMonth = helper.extractMonth(inDate: Date.init());
        calendarLabel.text = currentMonth;
        daysLeftLabel.text = "\(helper.monthDaysLeft()) days left";
    }
    
    @objc func fetchData(){
        // Get transaction values from User defaults for current month and sort by date
        
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            
            // Filter according to current month
            displayTransactions = fetchedTransactions.filter{
                helper.extractMonth(inDate: $0.date!) == currentMonth
            }
        }
    }
    
    @objc func getCurrentValues(){
        // Update values for Income, Expense and Balance
        
        for transaction in displayTransactions{
            if(transaction.type == "Income"){
                currentIncome = currentIncome + transaction.amount!;
            }
            else if(transaction.type == "Expense"){
                currentExpense = currentExpense + transaction.amount!;
            }
            
        }
        balance = currentIncome - currentExpense;
        
        if(UserDefaults.standard.value(forKey: "Currency") != nil){
            currencyValue = UserDefaults.standard.value(forKey: "Currency") as! String;
        }
    }
    
    @objc func getCurrentBudget(){
        // Fetch budget data from user defaults

        if let data = UserDefaults.standard.value(forKey: "Budget") as? Data {
            budgetList = try! PropertyListDecoder().decode(Array<Budget>.self, from: data)
            
            for budget in budgetList{
                if(budget.monthYear == currentMonth){
                    // Set progress and values if budget already setup for selected month
                    
                    budgetValue = budget.budgetValue;
                    budgetAmountInput.text = String(budgetValue);
                    totalBudgetLabel.text = String("\(currencyValue) \(budgetValue)");
                    budgetProgress = Float((balance)/budgetValue);
                    budgetLevelBar.setProgress(Float(budgetProgress), animated: false);
                    
                    
                    if(budgetProgress < 0.2){
                        budgetLevelBar.progressTintColor = UIColor.red;
                    }
                    else if(budgetProgress > 0.2 && budgetProgress < 0.7){
                        budgetLevelBar.progressTintColor = UIColor.orange;
                    }
                    else if(budgetProgress > 0.7){
                        budgetLevelBar.progressTintColor = UIColor.green;
                    }
                    
                    if(balance < budgetValue){
                        let amt = budgetValue - balance;
                        budgetLeftLabel.text = "You need \(currencyValue) \(amt) more";
                    }
                    else if(balance > budgetValue){
                        let amt = balance - budgetValue;
                        budgetLeftLabel.text = "You have \(currencyValue) \(amt) surplus";
                    }
                    else if(balance == budgetValue){
                        budgetLeftLabel.text = "Your budget is fulfilled";
                    }
                }
            }     
        }
    }
    
    @objc func validateTransaction() -> Bool{
        // Validate if values for transaction are correct
        
        var flag = true;
        if(Float(budgetAmountInput.text!) ?? 0 == 0 || String(budgetAmountInput.text!).trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            helper.showToast(message: "Invalid Budget", view: self.view, type: "Error");
            flag = false;
        }
        return flag;
    }
 
    @IBAction func budgetUpdate(_ sender: Any) {
        // Fetch all budget values and Add/Update current budget
        
        let validate = validateTransaction();
        
        if(validate){
        
            
            
            
            let newBudget: Budget = Budget(budgetValue: Double(String(budgetAmountInput.text!))!, monthYear: currentMonth, currency: currencyValue);
            
            if let data = UserDefaults.standard.value(forKey: "Budget") as? Data {
                budgetList = try! PropertyListDecoder().decode(Array<Budget>.self, from: data)
                for (index,budget) in budgetList.enumerated(){
                    if(budget.monthYear == currentMonth){
                        budgetList.remove(at: index);
                    }
                }
        }
        
        budgetList.append(newBudget);
            
        
        helper.showToast(message: "Budget changed", view: self.view, type: "Success")
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(budgetList), forKey: "Budget");
        getCurrentBudget();
        }
    }
    
}
