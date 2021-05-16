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
    
    var currentDate: Date = Date.init();
    
    var incomeCategories = ["Deposits", "Salary", "Savings"];
    var expenseCategories = ["Restaurant", "Grocery", "Shopping", "Housing", "Transportation", "Vehicle", "Entertainment", "Communication"];
    let dropDown = DropDown();
    
    var fetchedTransactions: [Transaction] = [];
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad(); 
        
        dropDown.anchorView = dropDownView;
        dropDown.dataSource = incomeCategories;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)");
            categoryLabel.text = item;
            
        }
        
        
        transactionAmount.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0);
//        dropDown.show();
    

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    
    @IBAction func dateUpdated(_ sender: Any) {
//        let dateFormatterGet = DateFormatter();
//        dateFormatterGet.dateFormat = "MMM dd, yyyy HH:mm";
//        let xDate = dateFormatterGet.string(from: transactionDate.date)
//        print(xDate);
//        currentDate = transactionDate.date;
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
            let transactionId: String = UUID.init().uuidString;
            
            if(transactionType.selectedSegmentIndex == 0){
                type = "Income";
            }
            else{
                type = "Expense";
            }
            
            let dateFormatterGet = DateFormatter();
            dateFormatterGet.dateFormat = "MMM dd, yyyy HH:mm";
            print(dateFormatterGet.string(from: transactionDate.date));
            print(transactionDate.date);
//            let xDate = dateFormatterGet.string(from: transactionDate.date)
            
            let amount: Double = Double(transactionAmount.text ?? "") ?? 0;
            
            print("kitna \(amount)")
            let newTransaction = Transaction(id: transactionId, amount: amount, description: transactionDescription.text ?? "", type: type, category: categoryLabel.text ?? "", date: transactionDate.date, currency: "AUD");
            
            if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
                fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
                print(fetchedTransactions);
            }
            
            
            fetchedTransactions.append(newTransaction);
            
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(fetchedTransactions), forKey: "Transactions");
            fetchedTransactions = [];
            
    }

}
