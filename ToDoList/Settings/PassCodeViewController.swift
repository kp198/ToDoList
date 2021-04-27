//
//  PassCodeViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 25/04/21.
//

import UIKit

enum PassCodeErrors: Int {
    case passCodeMismatch
    case passCodeTooSmall
    case userNotCompletedTyping
    case passCodeCorrect
    case undeterminedError
}

class PassCodeViewController:UIViewController {
    let passCodeTable = UITableView.init()
    let enterField = UITextField()
    let reenterField = UITextField()
    var footerMessage = NSAttributedString(string: "Set a password with atleast 8 characters")
    let switch1 = UISwitch(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
    let switch2 = UISwitch(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .red
        self.navigationItem.title = "Passcode"
       footerMessage = footerMessage.setAttributedText(font: fontName.Avenir_Medium.rawValue, color: UIColor.init(red: 186/255, green: 182/255, blue: 183/255, alpha: 1.0), size: 15)
        passCodeTable.backgroundColor = .white
        self.view.addSubview(passCodeTable)
        self.passCodeTable.translatesAutoresizingMaskIntoConstraints = false
        self.passCodeTable.setUpStandardTable(viewController: self)
        passCodeTable.delegate = self
        passCodeTable.dataSource = self
        setUpDoneButton()
        self.passCodeTable.tableFooterView = UIView()
    }
    
    func setUpDoneButton() {
        let done = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        done.setTitle("Done", for: .normal)
        done.sizeToFit()
        done.setTitleColor(.red, for: .normal)
        done.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: done)
    }
    
    @objc func donePressed(){
        let check = checkPassCodeFields()
        switch check {
            case PassCodeErrors.passCodeMismatch.rawValue:
                self.showAlert(title: "PassCode Mismatch", message: "Passwords entered must match", preferredStyle: .alert)
            case PassCodeErrors.passCodeTooSmall.rawValue:
                self.showAlert(title: "PassCode Too Small", message: "Passwords entered must be 8 characters or longer", preferredStyle: .alert)
            case PassCodeErrors.undeterminedError.rawValue:
            self.showAlert(title: "Unknown Error", message: "Sorry For The Inconvenience", preferredStyle: .alert)
        case PassCodeErrors.passCodeCorrect.rawValue:
            self.savePassWord()
        default:
            break
        }
    }
    
    func checkPassCodeFields() -> Int {
        if userCompletedTyping() {
            if enterField.text != reenterField.text {
                return PassCodeErrors.passCodeMismatch.rawValue
            } else if enterField.text != nil && enterField.text!.count < 8 {
                return PassCodeErrors.passCodeTooSmall.rawValue
            } else if enterField.text == nil {
                return PassCodeErrors.undeterminedError.rawValue
            } else {
                return PassCodeErrors.passCodeCorrect.rawValue
            }
        } else {
            return PassCodeErrors.userNotCompletedTyping.rawValue
        }
    }
    
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style,okCompletion: ((UIAlertAction)->())? = nil,cancelCompletion: ((UIAlertAction)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(.init(title: "Ok", style: .default, handler: okCompletion))
        if cancelCompletion != nil {
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: cancelCompletion))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func savePassWord() {
        showAlert(title: "Important Alert", message: "Since there are currently no available recovery mechanisms, all data will be deleted if you forget your password", preferredStyle: .alert,okCompletion: {_ in
            UserDefaults.standard.setValue(self.enterField.text!, forKey: "passCode")
            self.showAlert(title: "Password Saved Successfully!", message: nil, preferredStyle: .alert)
        },cancelCompletion: {
            _ in
        })
    }
}

extension PassCodeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let d = Date.init()
        print(d.timeIntervalSince1970, d.timeIntervalSince1970 - Double(Date.init().timeIntervalSince1970))
        let cell = UITableViewCell.init()
        cell.backgroundColor = .white
        switch indexPath.row {
        case 0:
            cell.textLabel?.attributedText = NSAttributedString(string: "PASSWORD LOCK").setAttributedText(font: fontName.GillSans_SemiBold.rawValue , size: 15)
            cell.accessoryType = .detailButton
        case 1:
            cell.textLabel?.attributedText = NSAttributedString(string: "PASSWORD").setAttributedText(font: fontName.GillSans_SemiBold.rawValue , size: 15)
        case 2:
            self.addTextFieldToCell(cell: cell, textField: enterField,tag: 10)
            cell.selectionStyle = .none
        case 3:
            cell.textLabel?.attributedText = NSAttributedString(string: "CONFIRM PASSWORD").setAttributedText(font: fontName.GillSans_SemiBold.rawValue , size: 15)
        case 4:
            self.addTextFieldToCell(cell: cell, textField: reenterField,tag: 12)
        case 5:
            cell.textLabel?.attributedText = self.footerMessage
        case 6:
            cell.textLabel?.attributedText = NSAttributedString(string: "Require Pass Code Immediately").setAttributedText(font: fontName.AppleColorEmoji.rawValue, size: 15)
            switch1.isOn = true
            switch1.addTarget(self, action: #selector(immediateLock(button:)), for: .touchUpInside)
            cell.accessoryView = switch1
        case 7:
            cell.textLabel?.attributedText = NSAttributedString(string: "Require Pass Code After an hour").setAttributedText(font: fontName.AppleColorEmoji.rawValue, size: 15)
            switch2.isOn = false
            switch2.addTarget(self, action: #selector(hourLock(button:)), for: .valueChanged)
            cell.accessoryView = switch2
        default:
            break
            
        }
        return cell
    }
    
    @objc func immediateLock(button: UISwitch) {
        if button.isOn {
            UserDefaults.standard.set(nil, forKey: "passCodeTimer")
        } else {
            
        }
    }
    
    @objc func hourLock(button: UISwitch) {
        if button.isOn {
            if UserDefaults.standard.value(forKey: "passCodeTimer") == nil {
                UserDefaults.standard.set(Double(Date.init().timeIntervalSince1970), forKey: "passCodeTimer")
            }
        } else {
            UserDefaults.standard.set(nil, forKey: "passCodeTimer")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == tableView.numberOfSections - 1 {
//            return 48
//        }
//        return .leastNormalMagnitude
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = UIView()
//        let footerLabel = UILabel()
//        footerLabel.text = self.footerMessage
//        footer.frame = CGRect(x: 30, y: 0, width: tableView.frame.size.width - 30, height: 48)
//        footer.addSubview(footerLabel)
//        footerLabel.frame = footer.frame
//        return footer
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
}

extension PassCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        showNotMatching()
    }
    
    func addTextFieldToCell(cell: UITableViewCell,textField: UITextField, tag: Int){
        cell.contentView.addSubview(textField)
        textField.tag = tag
        textField.placeholder = tag == 10 ? "Enter password" : "Re-Enter password for confirmation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor,constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor,constant: -50).isActive = true
        textField.topAnchor.constraint(equalTo: cell.contentView.topAnchor,constant: 0).isActive = true
        textField.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor,constant: -2).isActive = true
        textField.isSecureTextEntry = true
        textField.delegate = self
        let showPassButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        cell.accessoryView = showPassButton
        showPassButton.setImage(UIImage(named: "showpass"), for: .normal)
        showPassButton.tag = tag
        showPassButton.addTarget(self, action: #selector(showPassword(button:)), for: .touchUpInside)
    }
    
    func userCompletedTyping() -> Bool {
       return !reenterField.isEmpty() && !enterField.isEmpty()
    }
    
    func showNotMatching() {
        if !userCompletedTyping() {
            return
        }
        if reenterField.text != enterField.text {
            footerMessage = footerMessage.setAttributedText(string: "Passwords don't match",font: fontName.Avenir_Medium.rawValue, color: UIColor.red, size: 15)
                
        } else if (enterField.text?.count ?? 9 < 8) {
            footerMessage = footerMessage.setAttributedText(string: "Please enter password of length 8",font: fontName.Avenir_Medium.rawValue, color: UIColor.init(red: 21/255, green: 147/255, blue: 240/255, alpha: 1.0), size: 15)
        }
        passCodeTable.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
    }
    
    @objc func showPassword(button: UIButton) {
        if button.tag == 10 {
            enterField.isSecureTextEntry = button.isSelected
        } else {
            reenterField.isSecureTextEntry = button.isSelected
        }
        button.isSelected ?  button.setImage(UIImage(named: "showpass"), for: .normal) : button.setImage(UIImage(named: "hidepass"), for: .normal)
        button.isSelected = !button.isSelected
    }
}
