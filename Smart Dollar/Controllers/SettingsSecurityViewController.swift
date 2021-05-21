//
//  SettingsSecurityViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 20/05/21.
//

import UIKit
import AppLocker

class SettingsSecurityViewController: UIViewController {

    
    @IBOutlet weak var setPasscodeButton: UIButton!
    @IBOutlet weak var updatePasscodeBtn: UIButton!
    @IBOutlet weak var deactivatePasscodeBtn: UIButton!
    
    var options = ALOptions();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSetup();
        passcodeSetup();
    }
    
    func open() {

            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

  
        let securityPage = storyboard.instantiateViewController(withIdentifier: "SecurityPage") as! SettingsSecurityViewController
        
        let topViewController = UIApplication.shared.keyWindow?.rootViewController
        topViewController?.present(securityPage, animated: true, completion: nil)

    }
    
    @objc func screenSetup(){
        print(UserDefaults.standard.bool(forKey: "lock"));
        if((UserDefaults.standard.bool(forKey: "lock")) == false){
            updatePasscodeBtn.isHidden = true;
            deactivatePasscodeBtn.isHidden = true;
            setPasscodeButton.isHidden = false;
        }
        else if((UserDefaults.standard.bool(forKey: "lock")) == true){
            updatePasscodeBtn.isHidden = false;
            deactivatePasscodeBtn.isHidden = false;
            setPasscodeButton.isHidden = true;
        }
    }
    
    @objc func passcodeSetup(){
        options.image = UIImage(named: "lock")!;
        options.color = UIColor(red: 88/256, green: 86/256, blue: 214/256, alpha: 1.0)
        options.title = "Smart Dollar Safe";
        options.isSensorsEnabled = false;
        options.onSuccessfulDismiss = { (mode: ALMode?) in
            if let mode = mode {
               print("Password \(String(describing: mode))d successfully");
                self.validateMode(mode: mode);
                self.screenSetup();
            }
            else {
               print("User Cancelled");
            }
        }
        options.onFailedAttempt = { (mode: ALMode?) in
        print("Failed to \(String(describing: mode))");
          
        }
    }
    
    func validateMode(mode: ALMode){
        if(mode == ALMode.create){
            UserDefaults.standard.set(true, forKey: "lock");
        }
        else if(mode == ALMode.deactive){
            UserDefaults.standard.set(false, forKey: "lock");
        }
        
        print(UserDefaults.standard.bool(forKey: "lock"));
    }

    
    @IBAction func setPasscode(_ sender: Any) {
    
        AppLocker.present(with: .create, and: options, over: self);
        
       }
    
    @IBAction func updatePasscode(_ sender: Any) {
        
        AppLocker.present(with: .change, and: options, over: self);
        
    }
    @IBAction func deactivatePasscode(_ sender: Any) {
        
        AppLocker.present(with: .deactive, and: options, over: self);
        
    }
}
