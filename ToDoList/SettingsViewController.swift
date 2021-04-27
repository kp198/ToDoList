//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit

protocol SettingsDelegate: FontsDelegate,AccountsDelegate,LoginPassCodeHandler {
    func strikeThroughStateChanged(val: Bool)
    func getStrikeThroughState() -> Bool
}

class SettingsViewController: UIViewController {
    let settingsTable = UITableView.init()
    let settingsOptions = ["Account","Change Font","Themes","Feature Request","Strike Through on Completion","Privacy Policy"]
    weak var delegate: SettingsDelegate? {
        didSet {
            self.settingsTable.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.addShadow(color: .gray)
        self.setTable()
        self.navigationItem.title = "Settings"
        self.settingsTable.tableFooterView = UIView()
    }
    
    func setTable() {
        self.view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        settingsTable.backgroundColor = UIColor.white
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.setUpStandardTable(viewController: self)
        
    }
    
    @objc func dismissOnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        cell.textLabel?.attributedText = NSAttributedString(string: settingsOptions[indexPath.row], attributes: [.foregroundColor: UIColor.black,.font : UIFont(name: fontName.Georgia_Bold.rawValue, size: 14)!])
        if indexPath.row == 4 {
            let strikeSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 45, height: 25))
            strikeSwitch.isOn = delegate?.getStrikeThroughState() ?? false
            strikeSwitch.addTarget(self, action: #selector(chooseStrike(strikeSwitch:)), for: .valueChanged)
            cell.accessoryView = strikeSwitch
        }
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
            case 5:
                showPrivacyPolicy()
            default:
                break
        }
    }
    
    func showAccountsPage() {
        let accountsController = AccountViewController.init()
        accountsController.delegate = self.delegate
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
    
    func showPrivacyPolicy() {
        let privacy = PrivacyViewController.init()
        privacy.delegate = self.delegate
        self.presentInNavController(viewControler: privacy)
    }
    
    func presentInNavController(viewControler: UIViewController) {
        self.navigationController?.pushViewController(viewControler, animated: true)
//        viewControler.modalPresentationStyle = .formSheet
//        self.navigationController?.present(UINavigationController(rootViewController: viewControler), animated: true, completion: nil)
    }
  
    @objc func chooseStrike(strikeSwitch: UISwitch) {
        delegate?.strikeThroughStateChanged(val: strikeSwitch.isOn)
    }
}



class PrivacyViewController: UIViewController {
    
    weak var delegate: LoginPassCodeHandler?
    let privacyTable = UITableView.init()
    override func viewDidLoad() {
        self.view.addSubview(privacyTable)
        privacyTable.translatesAutoresizingMaskIntoConstraints = false
        privacyTable.setUpStandardTable(viewController: self)
        privacyTable.delegate = self
        privacyTable.dataSource = self
        privacyTable.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.white
        privacyTable.backgroundColor = UIColor.white
    }
}

extension PrivacyViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.backgroundColor = UIColor.white
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Reset To Default Settings"
        case 1:
            cell.textLabel?.text = "Clear User Related Data"
        case 2:
            cell.textLabel?.text = "Clear All Data"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            resetToDefaultSettings()
        case 1:
            print("ch1")
            clearUserData()
        case 2:
            print("ch2")
            clearAllData()
        default:
            break
        }
    }
    
    func resetToDefaultSettings() {
        showAlert(title: "Alert", message: "Are you sure you want to restore to default Settings?", acceptAction: {
            _ in
            self.delegate?.resetSettings()
        }, cancelAction: {
            _ in
        })
    }
    
    func clearUserData() {
        showAlert(title: "Alert", message: "Are you sure you want to delete all user data? (userName,profilePic)", acceptAction: {
            _ in
            self.delegate?.clearUserData()
        }, cancelAction: {
            _ in
        })
    }
    
    func clearAllData() {
        showAlert(title: "Alert", message: "Are you sure you want to delete all user data? (userName,profilePic)", acceptAction: {
            _ in
            self.delegate?.deleteAllUserData()
        }, cancelAction: {
            _ in
        })
    }
    
    func showAlert(title: String, message: String, acceptAction: @escaping (UIAlertAction)->(), cancelAction: @escaping (UIAlertAction)->()) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: acceptAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction))
        self.present(alert, animated: true, completion: nil)
    }
    
}
