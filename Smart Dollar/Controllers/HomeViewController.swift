//
//  ViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit
import DropDown


class HomeViewController: UIViewController{
    
    
  
    
   
    let dropDown = DropDown();

    @IBOutlet weak var InpExp: UIView!
    @IBOutlet weak var MnthlyBudget: UIView!
    @IBOutlet weak var TransactionView: UIView!
    
    @IBOutlet weak var budgetLeftLabel: UILabel!
    @IBOutlet weak var budgetLevelBar: UIProgressView!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var transactionsTable: UITableView!;
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthSelector: UIView!
    var fetchedTransactions: [Transaction] = [];
    var filteredTransactions: [Transaction] = [];
    var budgetList: [Budget] = [];
    
    var income: Double = 0;
    var expense: Double = 0;
    var balance: Double = 0;
    var selectedMonth = "";
    var budgetValue: Double = 0;
    var budgetProgress: Float = 0;
//    var pickerData: [String] = [];
    
    let helper = Helper();
    
//    let picker = MonthYearPicker(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
//    picker.minimumDate = Date()
//    picker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
//    picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//    view.addSubview(picker)
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true;
        
        fetchData();
//        setPickerData();
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
        
        TransactionView.layer.shadowColor = UIColor.gray.cgColor
        TransactionView.layer.shadowOpacity = 1
        TransactionView.layer.shadowOffset = .zero
        TransactionView.layer.shadowRadius = 10
        TransactionView.layer.cornerRadius = 20
        TransactionView.layer.masksToBounds = true
        
        dropDown.anchorView = monthSelector;
        dropDown.dataSource = helper.getMonths();
        dropDown.selectRow(4);
        monthLabel.text = dropDown.dataSource[4];
        selectedMonth = dropDown.dataSource[4];
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            print("Selected item: \(item) at index: \(index)");
            monthLabel.text = item;
            selectedMonth = item;
            fetchData();
            
        }
        fetchData();
//        setPickerData();
    }
    
    @objc func fetchData(){
        fetchedTransactions = [];
        filteredTransactions = [];
        income = 0;
        expense = 0;
        balance = 0;
        
        transactionsUpdate();
        valuesUpdate();
        getCurrentBudget();
    }
    

 
    @IBAction func dropDownClick(_ sender: Any) {
        dropDown.show();
//        dropDown.se
    }
    
    
//    @objc func setPickerData(){
//
//        pickerData = helper.getMonths();
//        dropDown.selectRow(5);
//        monthLabel.text = pickerData[5];
//
//    }
    
    @objc func transactionsUpdate(){
        if let data = UserDefaults.standard.value(forKey: "Transactions") as? Data {
            fetchedTransactions = try! PropertyListDecoder().decode(Array<Transaction>.self, from: data)
            fetchedTransactions.sort{
                $0.date > $1.date;
            }
            filteredTransactions = fetchedTransactions.filter { helper.extractMonth(inDate: $0.date) == selectedMonth }
            print(filteredTransactions);
        }
        transactionsTable.reloadData();
    }
    
    @objc func valuesUpdate(){
        for t in filteredTransactions {
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
    
    
    @objc func getCurrentBudget(){
        
//        var currentBudget: Budget;
        
        if let data = UserDefaults.standard.value(forKey: "Budget") as? Data {
            budgetList = try! PropertyListDecoder().decode(Array<Budget>.self, from: data)
            print("currentwa \(budgetList)")
            for budget in budgetList{
                if(budget.monthYear == selectedMonth){
                    print("pehle tha", budget);
                   
                    budgetValue = budget.budgetValue;
//                    budgetAmountInput.text = String(budgetValue);
//                    totalBudgetLabel.text = String(budgetValue);
                    budgetProgress = Float((balance)/budgetValue);
                    print(budgetProgress);
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
                        budgetLeftLabel.text = "You need $\(amt) more to reach your budget";
                    }
                    else if(balance > budgetValue){
                        let amt = balance - budgetValue;
                        budgetLeftLabel.text = "You have $\(amt) surplus on your budget";
                    }
                    else if(balance == budgetValue){
                        budgetLeftLabel.text = "Your budget is fulfilled";
                    }
//                    budgetLeftLabel.text = String(budgetValue - balance);
                    
                }
            }
           
            
        }
    }
   

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CELL");
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell;
        
        let helper = Helper();
       
        
        let transaction = filteredTransactions[indexPath.row];
//        print(helper.extractMonth(inDate: transaction.date));
        cell.id = transaction.id;
        cell.date = transaction.date;
        //cell.currencyLabel?.text = transaction.currency;
        cell.amountLabel?.text = transaction.currency + " $ " + String(transaction.amount);
        cell.categoryLabel?.text = transaction.category;
        //cell.typeLabel?.text = transaction.type;
        cell.dateLabel?.text = helper.dateToString(inDate: transaction.date);
        //cell.descriptionLabel?.text = transaction.description;
//        let name = fetchedTransactions[indexPath.row];
        
//        cell.textLabel?.text = name;
//        cell.detailTextLabel?.text = "100";
        let imgSrc = transaction.category;
        cell.transactionImg.image = UIImage(named: imgSrc);
        
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
        
        let name = filteredTransactions[indexPath.row];
        
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
    @IBOutlet weak var transactionImg: UIImageView!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
