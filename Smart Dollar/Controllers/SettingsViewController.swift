//
//  SettingsViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit
import AppLocker



struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(sETTINGSTableViewCell.self, forCellReuseIdentifier: sETTINGSTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
    }
    
    func configure() {
        models.append(Section(title: "Settings", options: [
            SettingsOption(title: "Name", icon: UIImage(named: "name.png"), iconBackgroundColor: .systemBlue) {
        },
        SettingsOption(title: "Currency", icon: UIImage(named: "currency.png"), iconBackgroundColor: .systemRed) {
                            },
        SettingsOption(title: "Security", icon: UIImage(named: "security.png"), iconBackgroundColor: .systemGreen) {
                            }
        ]))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: sETTINGSTableViewCell.identifier, for: indexPath
        ) as? sETTINGSTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: model)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
        
        if model.title == "Name" {

            
        }
        else if model.title == "Currency" {
            let sendValue = ChangeCurrency();
            sendValue.newcurrency()
            
            
        }
        else if model.title == "Security" {
            
        }
        
    }

}




  //  var options = ALOptions();
    
  //  override func viewDidLoad() {
    //    super.viewDidLoad()
    //    lockerLoader();
        // Do any additional setup after loading the view.
   // }
    
//    var opts
 //   @objc func lockerLoader(){
    
  //     options.image = UIImage(named: "lock")!;
    
  //  options.title = "Smart Dollar Safe";
  //  options.isSensorsEnabled = true;
       
  //  options.onSuccessfulDismiss = { (mode: ALMode?) in
   //     print("dekhba");
  //         if let mode = mode {
  //  print("Password \(String(describing: mode))d successfully");
  //         } else {
 //   print("User Cancelled");
  //         }
  //     }
  //     options.onFailedAttempt = { (mode: ALMode?) in
  //      print("naa dekhba");
 //   print("Failed to \(String(describing: mode))");
//       }
        
 //       AppLocker.present(with: .create, and: options)
 //   }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
