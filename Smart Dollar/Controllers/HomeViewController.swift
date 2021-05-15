//
//  ViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var InpExp: UIView!
    @IBOutlet weak var MnthlyBudget: UIView!
    
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionsTable: UITableView!;
    
    var fetchedTransactions: [Transaction] = [];
    var income: Double = 0;
    var expense: Double = 0;
    var balance: Double = 0;
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
        
        fetchData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
       
        // Do any additional setup after loading the view.
        
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
        
        
        fetchData();
    }
    
    @objc func fetchData(){
        fetchedTransactions = [];
        income = 0;
        expense = 0;
        balance = 0;
        
        transactionsUpdate();
        valuesUpdate();
    }
    
    @objc func transactionsUpdate(){
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            print(fetchedTransactions);
        }
        transactionsTable.reloadData();
    }
    
    @objc func valuesUpdate(){
        for t in fetchedTransactions {
            if(t.type == "Income"){
                income = income + t.amount;
            }
            else if(t.type == "Expense"){
                expense = expense + t.amount;
            }
        }
        balance = income - expense;
        balanceLabel.text = String("$ \(balance)");
        incomeLabel.text = String("$ \(income)");
        expenseLabel.text = String("$ \(expense)");
    }
    
   

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedTransactions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CELL");
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell;
        
        let helper = Helper();
       
        
        let transaction = fetchedTransactions[indexPath.row];
        print(helper.extractMonth(inDate: transaction.date));
        cell.id = transaction.id;
        cell.date = transaction.date;
        //cell.currencyLabel?.text = transaction.currency;
        cell.amountLabel?.text = String("$ \(transaction.amount)");
        cell.categoryLabel?.text = transaction.category;
        //cell.typeLabel?.text = transaction.type;
        cell.dateLabel?.text = helper.dateToString(inDate: transaction.date);
        //cell.descriptionLabel?.text = transaction.description;
//        let name = fetchedTransactions[indexPath.row];
        
//        cell.textLabel?.text = name;
//        cell.detailTextLabel?.text = "100";
        
        if(transaction.type == "Income"){
            cell.amountLabel?.textColor = UIColor(red: 33/256, green: 150/256, blue: 30/256, alpha: 1.0)

        }
        else{
            cell.amountLabel?.textColor = UIColor(red: 235/256, green: 87/256, blue: 87/256, alpha: 1.0)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! TransactionCell;
        print(currentCell.date);
        
        let name = fetchedTransactions[indexPath.row];
        
        print("Selected \(name)")
    }
}

class TransactionCell : UITableViewCell{
    var id: String = "";
    var date: Date = Date.init();
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
