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
  

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var transactionType: UISegmentedControl!
    
    var incomeCategories = ["Car", "Bike", "Cycle"];
    var expenseCategories = ["Bus", "Train", "PLane"];
    let dropDown = DropDown();
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad(); 
        
        dropDown.anchorView = dropDownView;
        dropDown.dataSource = incomeCategories;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in print("Selected item: \(item) at index: \(index)");
            categoryLabel.text = item;
            
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
        
        print(transactionType.selectedSegmentIndex);
        if(transactionType.selectedSegmentIndex == 0){
            dropDown.dataSource = incomeCategories;
        }
        else if(transactionType.selectedSegmentIndex == 1){
            dropDown.dataSource = expenseCategories;
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
//            dropDown.show();
//            print(transactionTypeSelector.selectedSegmentIndex);
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
        }
    }

}
