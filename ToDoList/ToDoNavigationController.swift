//
//  ToDoNavigationController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 26/04/21.
//

import UIKit

protocol ToDoNavigationDelegate: NSObjectProtocol {
    func settingsButtonTapped()
}

class ToDoNavigationController: UINavigationController {
    
    let settingsButton = UIButton()
    weak var navDelegate: ToDoNavigationDelegate?
    
    override func viewDidLoad() {
        self.navigationBar.backgroundColor = .red
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .red
        self.settingsButton.backgroundColor = .gray
        setUpLeftBarButtonItem()
    }
    
    func setUpLeftBarButtonItem() {
        self.navigationBar.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: self.navigationBar.topAnchor,constant: 10).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: self.navigationBar.bottomAnchor,constant: -10).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: self.navigationBar.leadingAnchor, constant: 20).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: self.navigationBar.frame.size.height-20).isActive = true
        settingsButton.layer.cornerRadius = (self.navigationBar.frame.size.height-20)/2
        settingsButton.layer.masksToBounds = true
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }
    func setImageInButton(image: UIImage) {
        settingsButton.setImage(image, for: .normal)
    }
    
    func setTitle(title: String) {
        settingsButton.setTitle(title, for: .normal)
    }
    
    @objc func settingsTapped() {
        navDelegate?.settingsButtonTapped()
    }
}

