//
//  ViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var InpExp: UIView!
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
       
        // Do any additional setup after loading the view.
        
        InpExp.layer.shadowColor = UIColor.black.cgColor
        InpExp.layer.shadowOpacity = 1
        InpExp.layer.shadowOffset = .zero
        InpExp.layer.shadowRadius = 10
    }
    
   

}

