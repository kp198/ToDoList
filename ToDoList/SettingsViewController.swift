//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit

protocol SettingsDelegate: FontsDelegate {
    
}

class SettingsViewController: UIViewController {
    let settingsTable = UITableView.init()
    let settingsOptions = ["Account","Change Font","","Feature Request"]
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTable()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Settings"
    }
    
    func setTable() {
        self.view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.setUpStandardTable(viewController: self)
        
    }
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.attributedText = NSAttributedString(string: settingsOptions[indexPath.row], attributes: [.foregroundColor: UIColor.black,.font : UIFont(name: fontName.Georgia_Bold.rawValue, size: 14)!])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            break
        case 1:
            showFonts()
        default:
            break
        }
    }
    
    func showFonts() {
        let fontViewController = FontViewController.init()
        fontViewController.delegate = self.delegate
        self.navigationController?.present(UINavigationController(rootViewController: fontViewController), animated: true, completion: nil)
//        self.present(UINavigationController(rootViewController: fontViewController), animated: true, completion: nil)
    }
  
}


extension UITableView {
    func setUpStandardTable(viewController: UIViewController) {
        if #available(iOS 11.0,*) {
            self.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor).isActive = true
        }
        self.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 10).isActive = true
        self.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -10).isActive = true
    }
}
