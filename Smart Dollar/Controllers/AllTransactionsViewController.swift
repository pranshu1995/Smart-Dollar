//
//  AllTransactionsViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 15/05/21.
//

import UIKit

class AllTransactionsViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var topTabBar: UITabBar!
    
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
        topTabBar.selectedItem = topTabBar.items![1] as UITabBarItem
        fetchData();
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            //This method will be called when user changes tab.
        print("chala \(item.title!)");
        if(item.title == "All"){
            displayTransactions = fetchedTransactions;
        }
        else if(item.title == "Income"){
            displayTransactions = filterTransactions(type: "Income");
        }
        else if(item.title == "Expense"){
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
                $0.date > $1.date;
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
        cell.id = transaction.id;
        cell.date = transaction.date;
        cell.currencyLabel?.text = transaction.currency;
        cell.amountLabel?.text = String(transaction.amount);
        cell.categoryLabel?.text = transaction.category;
        cell.typeLabel?.text = transaction.type;
        cell.dateLabel?.text = helper.dateToString(inDate: transaction.date);
        cell.descriptionLabel?.text = transaction.description;
//        let name = fetchedTransactions[indexPath.row];
        
//        cell.textLabel?.text = name;
//        cell.detailTextLabel?.text = "100";
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! AllTransactionsCell;
        print(currentCell.date);
        
        let name = displayTransactions[indexPath.row];
        
        print("Selected \(name)")
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
    
    
    
    
    
}



