//
//  LoginPassCodeViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 26/04/21.
//

import UIKit

class LoginPassCodeViewController: UIViewController {
    let passCodeField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
    var passCodeBottom = NSLayoutConstraint()
    let passCode: String
    let showPassCodeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    init(passCode: String) {
        self.passCode = passCode
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.addSubview(passCodeField)
        passCodeField.translatesAutoresizingMaskIntoConstraints = false
        passCodeField.attributedPlaceholder = NSAttributedString(string: "Enter your password").setAttributedText(font: fontName.TamilSangamMN.rawValue, size: 16)
        passCodeField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passCodeField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        passCodeField.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        passCodeField.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        let dummySpace = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
//        let showPassWord = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))//UIImageView(image: UIImage(named: "pencil"))
        showPassCodeButton.sizeToFit()
        showPassCodeButton.translatesAutoresizingMaskIntoConstraints = false
        showPassCodeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        showPassCodeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        showPassCodeButton.setImage(UIImage(named: "showpass"), for: .normal)
//        showPassWord.addTarget(self, action: #selector(showPassWord(v:)), for: .touchUpInside)
        passCodeField.rightView = showPassCodeButton
        showPassCodeButton.tag = 155
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPassWord))
        passCodeField.rightView?.addGestureRecognizer(tap)
        passCodeField.leftView = dummySpace
        passCodeField.leftViewMode = .always
        passCodeField.rightViewMode = .always
        passCodeField.contentMode = .redraw
        passCodeField.textAlignment = .center
        passCodeField.delegate = self
        passCodeBottom = passCodeField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        passCodeBottom.isActive = true
        passCodeField.layer.cornerRadius = 20
        
//        passCodeField.layer.shadowOffset = .zero
//        passCodeField.layer.shadowOpacity = 0.8
        passCodeField.autocorrectionType = .no
        passCodeField.autocapitalizationType = .none
        passCodeField.layer.borderColor = UIColor(red: 225/255, green: 230/255, blue: 233/255, alpha: 1.0).cgColor
        passCodeField.layer.borderWidth = 1.0
        passCodeField.textColor = .black
        passCodeField.isSecureTextEntry = true
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        if let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            passCodeBottom.constant = -frame.height
            if UIDevice.current.userInterfaceIdiom == .pad {
                passCodeBottom.constant += (UIScreen.main.bounds.size.height - self.view.frame.size.height)/2
            }
        }
    }
    
    @objc func hideKeyBoard(notification:NSNotification) {
        passCodeBottom.constant = 0
    }
    
    @objc func showPassWord(){
        if showPassCodeButton.tag == 155 {
            passCodeField.isSecureTextEntry = false
            showPassCodeButton.tag = 150
            showPassCodeButton.setImage(UIImage(named: "hidepass"), for: .normal)
        } else {
            passCodeField.isSecureTextEntry = true
            showPassCodeButton.tag = 155
            showPassCodeButton.setImage(UIImage(named: "showpass"), for: .normal)
        }
    }
    
}

extension LoginPassCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isHighlighted = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == passCode {
            self.dismiss(animated: true, completion: nil)
        } else if textField.isEmpty() {
            showAlert(title: "Please Enter The Passcode", message: nil)
        } else {
            showAlert(title: "Wrong PassCode Entered", message: nil)
        }
    }
    
    func showAlert(title: String?, message: String?){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
