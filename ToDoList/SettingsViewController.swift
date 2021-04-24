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
    let settingsOptions = ["Account","Change Font","Themes","Feature Request","Strike Through on Completion"]
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
        settingsTable.backgroundColor = UIColor.white
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
                showAccountsPage()
            case 1:
                showFonts()
            case 3:
                showFeatureRequest()
            default:
                break
        }
    }
    
    func showAccountsPage() {
        let accountsController = AccountViewController.init()
        self.presentInNavController(viewControler: accountsController)
    }
    
    func showFonts() {
        let fontViewController = FontViewController.init()
        fontViewController.delegate = self.delegate
        self.presentInNavController(viewControler: fontViewController)
//        self.present(UINavigationController(rootViewController: fontViewController), animated: true, completion: nil)
    }
    
    func showFeatureRequest() {
        let feature = FeatureRequestViewController.init()
        self.presentInNavController(viewControler: feature)
    }
    
    
    
    func presentInNavController(viewControler: UIViewController) {
        self.navigationController?.present(UINavigationController(rootViewController: viewControler), animated: true, completion: nil)
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
