//
//  NameViewController.swift
//  Smart Dollar
//
//  Created by Dilak Shakya on 21/5/21.
//

import UIKit

class NameViewController: UIViewController {

    // Outlet vaiables
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameButton: UIButton!
    
    
    // Helper class initialisation
    let helper = Helper();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setName(){
        // Open Name Editing view
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let NameView = storyboard.instantiateViewController(withIdentifier: "NameView") as! NameViewController
        
        let topViewController = UIApplication.shared.keyWindow?.rootViewController
        topViewController?.present(NameView, animated: true, completion: nil)
//        self.navigationController?.pushViewController(NameView, animated: true)
    }
    
    @IBAction func nameButtonPressed(_ sender: Any) {
        
        if(nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            helper.showToast(message: "Username Empty", view: self.view, type: "Error");
        }
        else{
            let userName = nameField.text
            UserDefaults.standard.set(userName, forKey: "userName");
            helper.showToast(message: "Username Added", view: self.view, type: "Success")
        }
    }
}
