//
//  HomeViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit
import DropDown
import AppLocker


class HomeViewController: UIViewController{

    // Outlet variables for the Homepage
    @IBOutlet weak var InpExp: UIView!
    @IBOutlet weak var MnthlyBudget: UIView!
    @IBOutlet weak var TransactionView: UIView!
    
    @IBOutlet weak var currBudgetLabel: UILabel!
    @IBOutlet weak var budgetLeftLabel: UILabel!
    @IBOutlet weak var budgetLevelBar: UIProgressView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionsTable: UITableView!;
    
    @IBOutlet weak var transactionViewStack: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthSelector: UIView!
    
    @IBOutlet weak var mnthContainer: UIControl!
    
    // Variables to store lists
    var fetchedTransactions: [Transaction] = [];
    var filteredTransactions: [Transaction] = [];
    var budgetList: [Budget] = [];
    
    // Variable to store data values
    var income: Double = 0;
    var expense: Double = 0;
    var balance: Double = 0;
    var selectedMonth = "";
    var budgetValue: Double = 0;
    var budgetProgress: Float = 0;
    
    // Helper class and Dropdown library initialisation
    let helper = Helper();
    let dropDown = DropDown();
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
        fetchData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        validateLock();
        
        // Hompage - UI setup + Dropdown + Fetch data from Userdefaults
        setupHomeUI()
        setupDropdown();
        fetchData();
    }
    
    @objc func validateLock(){
        print(UserDefaults.standard.bool(forKey: "lock"));
        print("presenta?");
        var options = ALOptions();
        options.image = UIImage(named: "lock")!;
        options.title = "Smart Dollar Safe";
        options.isSensorsEnabled = false;
        options.onSuccessfulDismiss = { (mode: ALMode?) in
            if let mode = mode {
               print("Password \(String(describing: mode))d successfully");
            }
            else {
               print("User Cancelled");
            }
            
        
    }
        
       if((UserDefaults.standard.bool(forKey: "lock")) == true){
            print("3?");
            AppLocker.present(with: .validate, and: options);
        }

    }
    
    @objc func setupDropdown(){
        // Dropdown setup for homescreen
        
        dropDown.anchorView = monthSelector;
        dropDown.dataSource = helper.getMonths();
        dropDown.selectRow(4);
        monthLabel.text = dropDown.dataSource[4];
        selectedMonth = dropDown.dataSource[4];
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            monthLabel.text = item;
            selectedMonth = item;
            fetchData();
            // Update on month selection
        }
    }
    
    @objc func setupHomeUI(){
        // Set UI values for screen elements
        
        InpExp.layer.shadowColor = UIColor.gray.cgColor
        InpExp.layer.shadowOpacity = 1
        InpExp.layer.shadowOffset = .zero
        InpExp.layer.shadowRadius = 10
        InpExp.layer.cornerRadius = 20
        InpExp.layer.masksToBounds = true
        
        MnthlyBudget.layer.shadowColor = UIColor.gray.cgColor
        MnthlyBudget.layer.shadowOpacity = 1
        MnthlyBudget.layer.shadowOffset = .zero
        MnthlyBudget.layer.shadowRadius = 10
        MnthlyBudget.layer.cornerRadius = 20
        MnthlyBudget.layer.masksToBounds = true
        
        TransactionView.layer.shadowColor = UIColor.gray.cgColor
        TransactionView.layer.shadowOpacity = 1
        TransactionView.layer.shadowOffset = .zero
        TransactionView.layer.shadowRadius = 10
        TransactionView.layer.cornerRadius = 20
        TransactionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        TransactionView.layer.masksToBounds = true
        
        mnthContainer.layer.shadowColor = UIColor.gray.cgColor
        mnthContainer.layer.shadowOpacity = 1
        mnthContainer.layer.shadowOffset = .zero
        mnthContainer.layer.shadowRadius = 10
        mnthContainer.layer.cornerRadius = 20
        mnthContainer.layer.masksToBounds = true
        
        transactionsTable.layer.shadowColor = UIColor.gray.cgColor
        transactionsTable.layer.shadowOpacity = 1
        transactionsTable.layer.shadowOffset = .zero
        transactionsTable.layer.shadowRadius = 10
        transactionsTable.layer.cornerRadius = 20
        transactionsTable.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        transactionsTable.layer.masksToBounds = true
    }
    
    @objc func fetchData(){
        // Data fetch from User Defaults and update all the elements and values for homescreen
        
        fetchedTransactions = [];
        filteredTransactions = [];
        
        transactionsUpdate();
        valuesUpdate();
        getCurrentBudget();
    }
    
    @objc func transactionsUpdate(){
        // Fetch transactions from User defaults and fulter according to the selected month
        
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            
            // Sort data by date
            fetchedTransactions.sort{
                $0.date! > $1.date!;
            }
            
            // Filter according to the selected month
            filteredTransactions = fetchedTransactions.filter{
                helper.extractMonth(inDate: $0.date!) == selectedMonth
            }
        }
        
        // Reload table data
        transactionsTable.reloadData();
    }
    
    @objc func valuesUpdate(){
        // Update values for Income, Expense and Balance
        
        income = 0;
        expense = 0;
        balance = 0;
        
        for t in filteredTransactions {
            if(t.type == "Income"){
                income = income + t.amount!;
            }
            else if(t.type == "Expense"){
                expense = expense + t.amount!;
            }
        }
        balance = income - expense;
        
        // Update labels
        balanceLabel.text = String("$ \(balance)");
        incomeLabel.text = String("$ \(income)");
        expenseLabel.text = String("$ \(expense)");
    }

    @objc func getCurrentBudget(){
        // Fetch budget data from user defaults
        
        if let data = UserDefaults.standard.value(forKey: "Budget") as? Data {
            budgetList = try! PropertyListDecoder().decode(Array<Budget>.self, from: data)
            
            for budget in budgetList{
                if(budget.monthYear == selectedMonth){
                    // Set progress and values if budget already setup for selected month
                    
                    currBudgetLabel.text = "$ \(String(budget.budgetValue))" ;
                    budgetValue = budget.budgetValue;
                    budgetProgress = Float((balance)/budgetValue);
                    budgetLevelBar.setProgress(Float(budgetProgress), animated: false);
                    budgetLeftLabel.textColor = UIColor.black;
                    
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
                        budgetLeftLabel.text = "You need $\(amt) more to reach your budget";
                    }
                    else if(balance > budgetValue){
                        let amt = balance - budgetValue;
                        budgetLeftLabel.text = "You have $\(amt) surplus on your budget";
                    }
                    else if(balance == budgetValue){
                        budgetLeftLabel.text = "Your budget is fulfilled";
                    }
                }
                else{
                    // Set values for month with no budget
                    
                    budgetLeftLabel.text = "No budget available for this month";
                    currBudgetLabel.text = "NA";
                    budgetLeftLabel.textColor = UIColor.red;
                    budgetLevelBar.setProgress(1, animated: false);
                    budgetLevelBar.progressTintColor = UIColor.red;
                }
            }
        }
    }
    

 
    @IBAction func dropDownClick(_ sender: Any) {
        // Display dropdown on click
        
        dropDown.show();
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    // Table view setup for Homescreen
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup cell values for custom cell created
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell;
        let transaction = filteredTransactions[indexPath.row];
        
        
        cell.id = transaction.id!;
        cell.date = transaction.date!;
        cell.amountLabel?.text = transaction.currency! + " $ " + String(transaction.amount!);
        cell.categoryLabel?.text = transaction.category;
        cell.dateLabel?.text = helper.dateToString(inDate: transaction.date!);
        
        let imgSrc = transaction.category!;
        cell.transactionImg.image = UIImage(named: imgSrc);
        
        if(transaction.type == "Income"){
            cell.amountLabel?.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0)
        }
        else{
            cell.amountLabel?.textColor = UIColor(red: 235/256, green: 87/256, blue: 87/256, alpha: 1.0)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Function to fire on Table cell click/select
        
        let currentTransaction = filteredTransactions[indexPath.row];

        let transactionView: UIStoryboard = UIStoryboard(name: "TransactionAddStoryboard", bundle: nil)
        let vc = transactionView.instantiateViewController(identifier: "TransactionAddViewController") as! TransactionAddViewController
        self.navigationController?.pushViewController(vc, animated: true)
        vc.newTransaction = false;
        vc.currentTransaction = currentTransaction;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Deleting value from table
        
        if editingStyle == .delete {
            let currentTransaction = filteredTransactions[indexPath.row];
            helper.deleteTransaction(id: currentTransaction.id!); // Delete from User Defaults
            filteredTransactions.remove(at: indexPath.row) // Delete from current list
            for (index,transaction) in fetchedTransactions.enumerated(){
                if(transaction.id! == currentTransaction.id){
                    fetchedTransactions.remove(at: index); // Delete from main list
                }
            }
            // Update Homescreen variables and values after deletion
            valuesUpdate();
            getCurrentBudget();
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
}

class TransactionCell : UITableViewCell{
    // Custom cell for the Transaction Table
    
    var id: String = "";
    var date: Date = Date.init();
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
 
    
    @IBOutlet weak var transactionImg: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
