//
//  SettingsViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit
import AppLocker


class SettingsViewController: UIViewController {

    var options = ALOptions();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lockerLoader();
        // Do any additional setup after loading the view.
    }
    
//    var opts
    @objc func lockerLoader(){
    
       options.image = UIImage(named: "lock")!;
    
    options.title = "Smart Dollar Safe";
    options.isSensorsEnabled = true;
       
    options.onSuccessfulDismiss = { (mode: ALMode?) in
        print("dekhba");
           if let mode = mode {
    print("Password \(String(describing: mode))d successfully");
           } else {
    print("User Cancelled");
           }
       }
       options.onFailedAttempt = { (mode: ALMode?) in
        print("naa dekhba");
    print("Failed to \(String(describing: mode))");
       }
        
        AppLocker.present(with: .create, and: options)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
