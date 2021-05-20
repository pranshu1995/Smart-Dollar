//
//  TransactionAddViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit
import DropDown


class TransactionAddViewController: UIViewController {
    // Page for Adding a transaction
    
    // Outlet variables
    @IBOutlet weak var dropDownView: UIView!;
    @IBOutlet weak var transactionDescription: UITextField!
  
    @IBOutlet weak var transactionDate: UIDatePicker!
    
    @IBOutlet weak var transactionAmount: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var transactionType: UISegmentedControl!
    
    @IBOutlet weak var btnLabel: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    // Variable for data values
    var newTransaction = true;
    var currentTransaction: Transaction = Transaction();
    var transactionId: String = UUID.init().uuidString;
    
    // Categories for Income and Expenses
    var incomeCategories = ["Deposits", "Salary", "Savings"];
    var expenseCategories = ["Restaurant", "Grocery", "Shopping", "Housing", "Transportation", "Vehicle", "Entertainment", "Communication"];
   
    // List for storing Transactions
    var fetchedTransactions: [Transaction] = [];
    
    // Helper class and Dropdown library initialisation
    let helper = Helper();
    let dropDown = DropDown();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupDropdown();
        
        if(newTransaction == true){
            // Setup screen if transaction is new
            
            dropDown.dataSource = incomeCategories;
            transactionAmount.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0);
            btnLabel.setTitle("Add", for: .normal);
            deleteBtn.isHidden = true;
        }
        else{
            // Setup screen if updating an already present transaction
            
            btnLabel.setTitle("Update", for: .normal);
            deleteBtn.isHidden = false;
            
            // Set transaction properties
            transactionId = currentTransaction.id!
            transactionDescription.text = currentTransaction.description!;
            transactionDate.date = currentTransaction.date!;
            transactionAmount.text = String(currentTransaction.amount!);
            
            if(currentTransaction.type == "Income"){
                transactionType.selectedSegmentIndex = 0;
                dropDown.dataSource = incomeCategories;
                transactionAmount.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0);
            }
            else if(currentTransaction.type == "Expense"){
                transactionType.selectedSegmentIndex = 1;
                dropDown.dataSource = expenseCategories;
                transactionAmount.textColor = UIColor(red: 235/256, green: 87/256, blue: 87/256, alpha: 1.0)
            }
            
            categoryLabel.text = currentTransaction.category!;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    @objc func setupDropdown(){
        //  Dropdown setup for Transaction page
        
        dropDown.anchorView = dropDownView;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        categoryLabel.text = item;
        }
    }
    
    @objc func refreshPage(){
        // Refresh current page values
        
        newTransaction = true;
        currentTransaction = Transaction();
        transactionId = UUID.init().uuidString;
        fetchedTransactions = [];
        btnLabel.setTitle("Add", for: .normal);
        deleteBtn.isHidden = true;
        transactionDescription.text = "";
        transactionDate.date = Date.init();
        transactionAmount.text = "";
        
    }
    
    @objc func validateTransaction() -> Bool{
        // Validate if values for transaction are correct
        
        var flag = true;
        if(categoryLabel.text == "Select Category"){
            helper.showToast(message: "Category not selected", view: self.view);
            flag = false;
        }
        else if(Float(transactionAmount.text!) ?? 0 == 0 || String(transactionAmount.text!).trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            helper.showToast(message: "Invalid Amount", view: self.view);
            flag = false;
        }
        return flag;
    }
    
    @IBAction func dropDownClick(_ sender: Any) {
        dropDown.show();
    }
    
    @IBAction func transactionTypeSelector(_ sender: Any) {
        // Switch between Income and Expense

        if(transactionType.selectedSegmentIndex == 0){
            dropDown.dataSource = incomeCategories;
            transactionAmount.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0);
        }
        else if(transactionType.selectedSegmentIndex == 1){
            dropDown.dataSource = expenseCategories;
            transactionAmount.textColor = UIColor(red: 235/256, green: 87/256, blue: 87/256, alpha: 1.0)
        }
        categoryLabel.text = "Select Category";
    }
    
    
    @IBAction func deleteTransaction(_ sender: Any) {
        // Delete current transaction
        
        helper.deleteTransaction(id: currentTransaction.id!);
        refreshPage();
    }
    
    
    @IBAction func addTransaction(_ sender: Any) {
        // Fetch all values from page and Add transaction to User Defaults
        
        let validate = validateTransaction(); // Validate data
        
        if(validate){
            // Pass only if validated
            
            let type: String;
            if(transactionType.selectedSegmentIndex == 0){
                type = "Income";
            }
            else{
                type = "Expense";
            }
            
            let amount: Double = Double(transactionAmount.text ?? "") ?? 0;

            // Transaction object creation
            let addTransaction = Transaction(id: transactionId, amount: amount, description: transactionDescription.text ?? "", type: type, category: categoryLabel.text ?? "", date: transactionDate.date, currency: "AUD");
            
            
            // Fetch currently available transactions
            if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
                fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
                print(fetchedTransactions);
            }
            
            if(newTransaction == false){
                // If updating transaction, delete old one and append new
                for (index,transaction) in fetchedTransactions.enumerated(){
                    if(transaction.id! == addTransaction.id){
                        fetchedTransactions.remove(at: index);
                    }
                }
            }
            
            fetchedTransactions.append(addTransaction);

            UserDefaults.standard.set(try? PropertyListEncoder().encode(fetchedTransactions), forKey: "Transactions");
            
            helper.showToast(message: "Trasaction Added", view: self.view)
            refreshPage();
        }
    }
}
