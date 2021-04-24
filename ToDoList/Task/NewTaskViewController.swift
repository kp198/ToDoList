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
    func deleteTask(taskNum: Int)
    func copyTask(taskNum: Int)
    func editTask()
}

class NewTaskViewController: UIViewController {
    let textBox = UITextView()
    var textBoxHeight = NSLayoutConstraint()
    var buttonLayerBottom = NSLayoutConstraint()
    let buttonsLayer = UIView()
    weak var delegate : NewTaskDelegate?
    init(text: String? = nil,delegate: NewTaskDelegate?) {
        
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        textBox.attributedText = NSAttributedString(string: text ?? "Add a New Task", attributes: [.foregroundColor:UIColor.gray,.font:  UIFont(name: delegate?.getFontName() ?? fontName.AppleSymbols.rawValue, size: 16)!])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,  selector: #selector(showKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        setUpTextBox()
        self.view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissOnTap)))
    }
    func setUpTextBox() {
        let boundaryView = UIView()
        boundaryView.backgroundColor = .red// UIColor.init(red: 236, green: 112, blue: 99, alpha: 1.0)
        boundaryView.layer.cornerRadius = 6
        self.view.addSubview(boundaryView)
        boundaryView.translatesAutoresizingMaskIntoConstraints = false
        boundaryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        boundaryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
//        boundaryView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//        if #available(iOS 11.0, *) {
//            boundaryView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
//        } else {
//            boundaryView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
//        }
        boundaryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        boundaryView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        boundaryView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 20).isActive = true
        boundaryView.addSubview(textBox)
        textBox.translatesAutoresizingMaskIntoConstraints = false
//        textBox.attributedText =
        textBoxHeight = textBox.heightAnchor.constraint(equalToConstant: 100)
        textBoxHeight.isActive = true
       
        textBox.leadingAnchor.constraint(equalTo: boundaryView.leadingAnchor).isActive = true
        textBox.trailingAnchor.constraint(equalTo: boundaryView.trailingAnchor).isActive = true
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        doneButton.setTitle("Done", for: .normal)
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
        buttonLayerBottom = buttonsLayer.bottomAnchor.constraint(equalTo: boundaryView.bottomAnchor, constant: 0)
        buttonLayerBottom.isActive = true
        buttonsLayer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonsLayer.backgroundColor = .gray
        textBox.bottomAnchor.constraint(equalTo: self.buttonsLayer.topAnchor, constant: 0).isActive = true
//        let path = UIBezierPath.init(roundedRect: CGRect(x: 10, y: self.view.frame.size.height - 140, width: self.view.frame.size.width - 20, height: 300), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 0, height: 6))
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.fillColor = UIColor.green.cgColor
//        boundaryView.layer.mask = shapeLayer
        textBox.isScrollEnabled = false
        textBox.becomeFirstResponder()
        setButtons()
    }
    
    func setButtons() {
        let copyButton = UIButton(frame: CGRect(x: 10, y: 10, width: 24, height: 24))
        let editButton = UIButton(frame: CGRect(x: 44, y: 10, width: 35, height: 35))
        let deleteButton = UIButton(frame: CGRect(x: 78, y: 10, width: 24, height: 24))
        let strikeThroughButton = UIButton(frame: CGRect(x: 114, y: 10, width: 50, height: 42))
        self.buttonsLayer.addSubview(strikeThroughButton)
        self.buttonsLayer.addSubview(copyButton)
        self.buttonsLayer.addSubview(editButton)
        self.buttonsLayer.addSubview(deleteButton)
        copyButton.setImage(UIImage(named: "copy"), for: .normal)
        editButton.setImage(UIImage(named: "pencil"), for: .normal)
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        strikeThroughButton.setAttributedTitle(NSAttributedString(string: "S", attributes: [.foregroundColor: UIColor.black,.strikethroughStyle: NSUnderlineStyle.single.rawValue]), for: .normal)
    }
    
    @objc func showKeyBoard(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        buttonLayerBottom.constant = -keyboardSize.height
    }
    
    @objc func dismissOnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func donePressed() {
        delegate?.addTask(task: self.textBox.text)
        self.dismissOnTap()
    }
}


extension NewTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        if textView.fr
    }
}
