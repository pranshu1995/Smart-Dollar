//
//  AllTransactionsViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 15/05/21.
//

import UIKit

class AllTransactionsViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var transactionType: UISegmentedControl!
    
    @IBOutlet weak var allTransactionsTable: UITableView!
    
    var fetchedTransactions: [Transaction] = [];
    var displayTransactions: [Transaction] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = false;
        fetchData();
    }
    
    @IBAction func transactionChange(_ sender: Any) {
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
    
    func filterTransactions(type: String) -> [Transaction]{
        var arr: [Transaction] = [];
        arr = fetchedTransactions.filter{ $0.type == type};
//        print(arr);
        return arr;
    }

    @objc func fetchData(){
        fetchedTransactions = [];
       
        
        transactionsUpdate();
        displayTransactions = fetchedTransactions;
    }
    
    @objc func transactionsUpdate(){
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            fetchedTransactions.sort{
                $0.date! > $1.date!;
            }
            print(fetchedTransactions);
        }
        allTransactionsTable.reloadData();
    }

}

extension AllTransactionsViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayTransactions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CELL");
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllTransactionsCell", for: indexPath) as! AllTransactionsCell;
        
        let helper = Helper();
       
        
        let transaction = displayTransactions[indexPath.row];
//        print(helper.extractMonth(inDate: transaction.date));
        cell.id = transaction.id!;
        cell.date = transaction.date!;
        //cell.currencyLabel?.text = transaction.currency;
        cell.amountLabel?.text = transaction.currency! + " $ " + String(transaction.amount!);
        cell.categoryLabel?.text = transaction.category;
        //cell.typeLabel?.text = transaction.type;
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
        
//        let name = fetchedTransactions[indexPath.row];
        
//        cell.textLabel?.text = name;
//        cell.detailTextLabel?.text = "100";
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentCell = tableView.cellForRow(at: indexPath) as! AllTransactionsCell;
//        print(currentCell.date);
        
        let currentTransaction = displayTransactions[indexPath.row];
        
        print("Selected \(currentTransaction) on \(indexPath.row)")
        let transactionView: UIStoryboard = UIStoryboard(name: "TransactionAddStoryboard", bundle: nil)
        let vc = transactionView.instantiateViewController(identifier: "TransactionAddViewController") as! TransactionAddViewController;
        self.navigationController?.pushViewController(vc, animated: true)
        vc.newTransaction = false;
        vc.currentTransaction = currentTransaction;
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            displayTransactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}


class AllTransactionsCell: UITableViewCell{
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



