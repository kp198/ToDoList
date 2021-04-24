//
//  FeatureRequestViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit

class FeatureRequestViewController: UIViewController {
    
    let textView = UITextView.init(frame: .zero)
    override func viewDidLoad() {
        self.setUpTextView()
        self.view.backgroundColor = .white
    }
    
    func setUpTextView() {
        let message = UILabel.init(frame: .zero)
        self.view.addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        message.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10).isActive = true
        if #available(iOS 11.0, *) {
            message.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        } else {
            message.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor,constant: 10).isActive = true
        }
        message.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        message.numberOfLines = 4
        message.attributedText = NSAttributedString(string: "Hey People!\n This is my first To Do List App. If you would like to see some additional features feel free to share it here.", attributes: [.foregroundColor : UIColor.black,.font: UIFont(name: fontName.Futura_Bold.rawValue, size: 15)!])
        
        self.view.addSubview(textView)
        textView.attributedText = NSAttributedString(string: "Type your feature request here!!", attributes: [.foregroundColor : UIColor.lightGray, .font: UIFont (name: fontName.AcademyEngravedLetPlain.rawValue, size: 14)!] )
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 10).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        textView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        textView.delegate = self
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 6
        
//        textView.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 10).isActive = true
        textView.tag = 0
    }
    
}

extension FeatureRequestViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.tag == 0) {
            textView.text = ""
        } else {
            textView.tag = 1
        }
    }
}
