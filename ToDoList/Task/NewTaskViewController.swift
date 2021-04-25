//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit
import Foundation

protocol NewTaskDelegate: NSObjectProtocol {
    func addTask(task: String)
    func getFontName() -> String
    func deleteTask(taskNum: Int?)
    func copyTask(taskNum: Int?)
    func editTask(taskNum: Int?,task: String)
}

class NewTaskViewController: UIViewController {
    let textBox = UITextView()
    var backgroundViewBottom = NSLayoutConstraint()
    let buttonsLayer = UIView()
    var taskNumber:Int? = nil
    weak var delegate : NewTaskDelegate?
    init(taskNum: Int? = nil,text: String? = nil,delegate: NewTaskDelegate?) {
        self.taskNumber = taskNum
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        textBox.attributedText = NSAttributedString(string: text ?? "Add a New Task", attributes: [.foregroundColor:UIColor.gray,.font:  UIFont(name: delegate?.getFontName() ?? fontName.AppleSymbols.rawValue, size: 16)!])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,  selector: #selector(showKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,  selector: #selector(hideKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        setUpTextBox()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissOnTap)))
    }
    func setUpTextBox() {
        textBox.delegate = self
        let boundaryView = UIView()
        boundaryView.backgroundColor = .white// UIColor.init(red: 236, green: 112, blue: 99, alpha: 1.0)
        boundaryView.layer.cornerRadius = 6
        self.view.addSubview(boundaryView)
        boundaryView.translatesAutoresizingMaskIntoConstraints = false
        boundaryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:  UIDevice.current.userInterfaceIdiom == .pad ? 0 : 10).isActive = true
        boundaryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 0 : -10).isActive = true
        backgroundViewBottom = boundaryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        backgroundViewBottom.isActive = true
       boundaryView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.view.addSubview(textBox)
        boundaryView.layer.cornerRadius = 6
        textBox.translatesAutoresizingMaskIntoConstraints = false
        textBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
       
        textBox.leadingAnchor.constraint(equalTo: boundaryView.leadingAnchor).isActive = true
        textBox.trailingAnchor.constraint(equalTo: boundaryView.trailingAnchor).isActive = true
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.red, for: .normal)
        boundaryView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.trailingAnchor.constraint(equalTo: boundaryView.trailingAnchor, constant: -10).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.topAnchor.constraint(equalTo: boundaryView.topAnchor).isActive = true
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        boundaryView.addSubview(buttonsLayer)
        buttonsLayer.translatesAutoresizingMaskIntoConstraints = false
        buttonsLayer.leadingAnchor.constraint(equalTo: boundaryView.leadingAnchor).isActive = true
        buttonsLayer.trailingAnchor.constraint(equalTo: boundaryView.trailingAnchor).isActive = true
        buttonsLayer.bottomAnchor.constraint(equalTo: boundaryView.bottomAnchor, constant: 0).isActive = true
        buttonsLayer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonsLayer.backgroundColor = .gray
        textBox.bottomAnchor.constraint(equalTo: self.buttonsLayer.topAnchor, constant: 0).isActive = true
        textBox.isScrollEnabled = false
        textBox.sizeToFit()
        textBox.becomeFirstResponder()
        setButtons()
    }
    
    func setButtons() {
        let copyButton = UIButton(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        let editButton = UIButton(frame: CGRect(x: 44, y: 10, width: 35, height: 35))
        let deleteButton = UIButton(frame: CGRect(x: 78, y: 10, width: 24, height: 24))
        let strikeThroughButton = UIButton(frame: CGRect(x: 114, y: 10, width: 50, height: 24))
        self.buttonsLayer.addSubview(strikeThroughButton)
        self.buttonsLayer.addSubview(copyButton)
        self.buttonsLayer.addSubview(editButton)
        self.buttonsLayer.addSubview(deleteButton)
        copyButton.setImage(UIImage(named: "copy"), for: .normal)
        editButton.setImage(UIImage(named: "pencil"), for: .normal)
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        strikeThroughButton.setAttributedTitle(NSAttributedString(string: "S", attributes: [.foregroundColor: UIColor.black,.strikethroughStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
        copyButton.addTarget(self, action: #selector(copyPressed), for: .touchUpInside)
        self.addTouchUpInsideTarget(button: deleteButton,selector: #selector(deletePressed))
    }
    
    @objc func hideKeyBoard() {
        backgroundViewBottom.constant = 0
    }
    
    @objc func showKeyBoard(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        backgroundViewBottom.constant = -keyboardSize.height
        if UIDevice.current.userInterfaceIdiom == .pad {
            backgroundViewBottom.constant += (UIScreen.main.bounds.size.height - self.view.frame.size.height)/2
        }
    }
    
    @objc func dismissOnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func donePressed() {
        if taskNumber == nil {
        delegate?.addTask(task: self.textBox.text)
        } else {
            delegate?.editTask(taskNum: taskNumber!, task: self.textBox.text)
        }
        self.dismissOnTap()
    }
    
    @objc func copyPressed() {
        delegate?.deleteTask(taskNum: taskNumber)
    }
    
    @objc func deletePressed() {
        delegate?.deleteTask(taskNum: taskNumber)
    }
    
    @objc func strikeThroughPressed() {
//        delegate?.
    }
}


extension NewTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

    }
    
    func addTouchUpInsideTarget(button: UIButton,selector: Selector){
        button.addTarget(self, action: selector, for: .touchUpInside)
    }
}
