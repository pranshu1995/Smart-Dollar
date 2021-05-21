//
//  SettingsViewController.swift
//  Smart Dollar
//
//  Created by Pranshu Midha on 10/05/21.
//

import UIKit




struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Settigns page table controller
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
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
        // Options on Settings page
        
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
            withIdentifier: SettingsTableViewCell.identifier, for: indexPath
        ) as? SettingsTableViewCell
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
            let userName = NameViewController();
            userName.setName()
            
        }
        else if model.title == "Currency" {
            let sendValue = ChangeCurrency();
            sendValue.newcurrency()
            
            
        }
        else if model.title == "Security" {
            let security = SettingsSecurityViewController();
            security.open();
        }
        
    }

}


