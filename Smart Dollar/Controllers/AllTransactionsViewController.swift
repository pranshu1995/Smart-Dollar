//
//  AllTransactionsViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 15/05/21.
//

import UIKit

class AllTransactionsViewController: UIViewController, UITabBarDelegate {
    // Page for displaying All transactions
    
    // Outlet variable for page
    @IBOutlet weak var transactionType: UISegmentedControl!
    
    @IBOutlet weak var allTransactionsTable: UITableView!
    
    
    // Variables to store data lists
    var fetchedTransactions: [Transaction] = [];
    var displayTransactions: [Transaction] = [];
    
    // Helper class initialisation
    let helper = Helper();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Update Segment UI and fetch data from User Defaults
        updateSegmentControl();
        fetchData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
        
        // Set View type to All
        transactionType.selectedSegmentIndex = 0;
        fetchData();
    }
    
    func filterTransactions(type: String) -> [Transaction]{
        // Filter transaction according to type selected
        
        var arr: [Transaction] = [];
        arr = fetchedTransactions.filter{ $0.type == type};
        return arr;
    }
    
    @objc func updateSegmentControl(){
        // Update Segement control UI
        
        transactionType.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)],for: .normal);
        
        transactionType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
    }

    @objc func fetchData(){
        // Fetch from user defaults and update table
        
        fetchedTransactions = [];
        displayTransactions = [];
        
        transactionsUpdate();
        displayTransactions = fetchedTransactions;
        allTransactionsTable.reloadData();
    }
    
    @objc func transactionsUpdate(){
        // Get transaction values from User defaults and sort by date
        
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            fetchedTransactions.sort{
                $0.date! > $1.date!;
            }
            print(fetchedTransactions);
        }
        
    }

    
    @IBAction func transactionChange(_ sender: Any) {
        // Update list and reload table on switching type
        
        if(transactionType.selectedSegmentIndex == 0){
                displayTransactions = fetchedTransactions;
        }
        else if(transactionType.selectedSegmentIndex == 1){
                displayTransactions = filterTransactions(type: "Income");
        }
        else if(transactionType.selectedSegmentIndex == 2){
                displayTransactions = filterTransactions(type: "Expense");
        }
        allTransactionsTable.reloadData();
    }
    
   
}

extension AllTransactionsViewController: UITableViewDelegate, UITableViewDataSource{
    // Extension for Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayTransactions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllTransactionsCell", for: indexPath) as! AllTransactionsCell;
 
        let transaction = displayTransactions[indexPath.row];
        
        cell.id = transaction.id!;
        cell.date = transaction.date!;
        cell.amountLabel?.text = transaction.currency! + " " + String(transaction.amount!);
        cell.categoryLabel?.text = transaction.category;
        cell.dateLabel?.text = helper.dateToString(inDate: transaction.date!);
        cell.descriptionLabel?.text = transaction.description;
        
        let imgSrc = transaction.category;
        cell.catIcon.image = UIImage(named: imgSrc!);
        
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
        
        let currentTransaction = displayTransactions[indexPath.row];
        
        print("Selected \(currentTransaction) on \(indexPath.row)")
        let transactionView: UIStoryboard = UIStoryboard(name: "TransactionAddStoryboard", bundle: nil)
        let vc = transactionView.instantiateViewController(identifier: "TransactionAddViewController") as! TransactionAddViewController;
        self.navigationController?.pushViewController(vc, animated: true)
        vc.newTransaction = false;
        vc.currentTransaction = currentTransaction;
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Deleting value from table
        
        if editingStyle == .delete {
            let currentTransaction = displayTransactions[indexPath.row];
            
            helper.deleteTransaction(id: currentTransaction.id!);
            
            displayTransactions.remove(at: indexPath.row);
            for (index,transaction) in fetchedTransactions.enumerated(){
                if(transaction.id! == currentTransaction.id){
                    fetchedTransactions.remove(at: index);
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


class AllTransactionsCell: UITableViewCell{
    // Custom cell for the Transaction Table
    
    var id: String = "";
    var date: Date = Date.init();
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var catIcon: UIImageView!
}



