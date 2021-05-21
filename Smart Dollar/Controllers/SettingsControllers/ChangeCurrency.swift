//
//  ChangeCurrency.swift
//  Smart Dollar
//
//  Created by Prajna Bhat on 18/5/21.
//

import UIKit

class ChangeCurrency: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // Currency Exchange controller
    
    // Helper class initialisation
    let helper = Helper();
    
    // Variable for data values
    var myCurrency:[String] = [];
    var activeCurrencyCode:String = "AUD";
    var currentCurrency: String = "AUD";
    
    // Outlet variable for page
    @IBOutlet weak var exchangeInput: UITextField!
    @IBOutlet weak var currencylabel: UILabel!
    
    
    @IBOutlet weak var ChangeButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var outputrate: UILabel!
    
 
    // UI Picker with currency list
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.activeCurrencyCode = self.myCurrency[row]
        return self.myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activeCurrencyCode = self.myCurrency[row]
    };

    
    func newcurrency() {

                // Create a reference to the the appropriate storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Instantiate the desired view controller from the storyboard using the view controllers identifier
        // Cast is as the custom view controller type you created in order to access it's properties and methods
        let ChangeCurrency = storyboard.instantiateViewController(withIdentifier: "CurrencyChange") as! ChangeCurrency
        
//        let topViewController = UIApplication.shared.keyWindow?.rootViewController
//        topViewController?.present(ChangeCurrency, animated: true, completion: nil)
//        
        self.navigationController?.pushViewController(ChangeCurrency, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Load current currency
        if(UserDefaults.standard.value(forKey: "Currency") != nil){
            currentCurrency = UserDefaults.standard.value(forKey: "Currency") as! String;
        }
        currencylabel.text = "Current currency is \(currentCurrency)"
    
        // Get and Set Data
        self.myCurrency = helper.currencyList;
        self.pickerView.reloadAllComponents();
    }

    @objc func validateExchange() -> Bool{
        // Validate if values for Exchange are correct
        
        var flag = true;
        if(Float(exchangeInput.text!) ?? 0 <= 0 || String(exchangeInput.text!).trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            helper.showToast(message: "Invalid Exchange Rate", view: self.view, type: "Error");
            flag = false;
        }
        else if(currentCurrency == activeCurrencyCode){
            helper.showToast(message: "Currency not changed", view: self.view, type: "Error");
            flag = false;
        }
        return flag;
    }
    
    //Button

    @IBAction func button(_ sender: UIButton) {
        //Main convertion FORMULA
       // outputRate.text = String(input * activeCurrency)

        //Showing Rates on screen
        if(validateExchange()){
        let exRate = Double(exchangeInput.text!);
            outputrate.text = "Currency updated with 1 \(currentCurrency) = \(exRate!) \(activeCurrencyCode)"
            
            // Update currency globally using Helper function
            helper.updateCurrency(newCurrency: activeCurrencyCode, exchangeRate: exRate!);
            
            
        }
    }
    
    

}
