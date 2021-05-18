//
//  TransactionAddViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit
import DropDown


class TransactionAddViewController: UIViewController {

    @IBOutlet weak var dropDownView: UIView!;
    @IBOutlet weak var transactionDescription: UITextField!
  
    @IBOutlet weak var transactionDate: UIDatePicker!
    
    @IBOutlet weak var transactionAmount: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var transactionType: UISegmentedControl!
    
    var newTransaction = true;
//    var transactionId = "";
    var currentTransaction: Transaction = Transaction();
    
    var transactionId: String = UUID.init().uuidString;
    var currentDate: Date = Date.init();
    
    var incomeCategories = ["Deposits", "Salary", "Savings"];
    var expenseCategories = ["Restaurant", "Grocery", "Shopping", "Housing", "Transportation", "Vehicle", "Entertainment", "Communication"];
    let dropDown = DropDown();
    
    var fetchedTransactions: [Transaction] = [];
    let helper = Helper();
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        dropDown.anchorView = dropDownView;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)");
            categoryLabel.text = item;
            
        }
        
        if(newTransaction == true){
            dropDown.dataSource = incomeCategories;
            transactionAmount.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0);
        }
        else{
            print("purana \(currentTransaction)");
            
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
        
       
        
       
        
        
        
//        dropDown.show();
    

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    
    @IBAction func dropDownClick(_ sender: Any) {
//        print("Andar");
        dropDown.show();
    }
    
    @IBAction func transactionTypeSelector(_ sender: Any) {
        
//        print(transactionType.selectedSegmentIndex);
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
    
//    private func setupDropdown(_ onLabel: UILabel) {
//        dropDown.anchorView = onLabel
//        dropDown.dataSource = ["sample1", "sample2", "sample3"]
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in print("Selected item: \(item) at index: \(index)");
//            onLabel.text = item
//
//        }
//
//    }
    
        @IBAction func addTransaction(_ sender: Any) {
            let type: String;
            
            if(transactionType.selectedSegmentIndex == 0){
                type = "Income";
            }
            else{
                type = "Expense";
            }
            
            let dateFormatterGet = DateFormatter();
            dateFormatterGet.dateFormat = "MMM dd, yyyy HH:mm";

//            let xDate = dateFormatterGet.string(from: transactionDate.date)
            
            let amount: Double = Double(transactionAmount.text ?? "") ?? 0;
            
            print("kitna \(amount)")
            let addTransaction = Transaction(id: transactionId, amount: amount, description: transactionDescription.text ?? "", type: type, category: categoryLabel.text ?? "", date: transactionDate.date, currency: "AUD");
            
            
            
            if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
                fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
                print(fetchedTransactions);
            }
            
            if(newTransaction == false){
                for (index,transaction) in fetchedTransactions.enumerated(){
                    if(transaction.id! == addTransaction.id){
                        fetchedTransactions.remove(at: index);
                        print("updated");
                    }
                }
            }
            
            fetchedTransactions.append(addTransaction);
            
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(fetchedTransactions), forKey: "Transactions");
            fetchedTransactions = [];
            
            helper.showToast(message: "Trasaction Added", view: self.view)
    }

}
