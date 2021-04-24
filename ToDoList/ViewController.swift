//
//  ViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit

class ViewController: UIViewController {

    let toDoTable = UITableView.init(frame: .zero, style: .grouped)
    var toDoList = [String]()
    var fontIndex = 0
    var userFontName = fontName.AmericanTypewriter.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoList = ["Build the app", "Test the app"]
        setUpFont()
        setUpToDoList()
        setUpSettingsView()
        
        self.navigationItem.title = "To Do List"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,.font: UIFont.init(name: fontName.NotoSansKannada_Bold.rawValue, size: 20)!]
        self.navigationController?.navigationBar.backgroundColor = .red
    }
    
    func setUpToDoList() {
        self.view.addSubview(toDoTable)
        toDoTable.translatesAutoresizingMaskIntoConstraints = false;
        toDoTable.delegate = self;
        toDoTable.dataSource = self;
        self.view.addSubview(toDoTable)
        toDoTable.setUpStandardTable(viewController: self)
    }
    
    func setUpSettingsView() {
        let settingsButton = UIButton(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
        
//        settingsButton.setImage(UIImage(named: "profilePic"), for: .normal)
//        settingsButton.imageView?.contentMode = .scaleAspectFit
//        settingsButton.imageView?.contentMode = .left
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
    }
    @objc func showSettings() {
        let settingsView = SettingsViewController.init()
        settingsView.delegate = self
        let navCont = UINavigationController(rootViewController: settingsView)
        self.present(navCont, animated: true, completion: nil)
    }
    
    func setUpFont() {
        if let fontDets = UserDefaults.standard.value(forKey: "userFont") as? [String:Any] , let fontName = fontDets["fontName"] as? String{
            userFontName = fontName
            fontIndex = fontDets["index"] as? Int ?? 0
        }
    }

}



extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ToDoListCustomTableCell(style: .default, reuseIdentifier: "cell", showCheckBox: 1,font: userFontName)
//        cell.setFont(font: userFontName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}


extension ViewController: SettingsDelegate {
    func selectedFont() -> Int {
        return fontIndex
    }
    
    func chosenFont(font: String,index: Int) {
        self.userFontName = font
        UserDefaults.standard.setValue(["fontName":font,"index":index], forKey: "userFont")
        reloadTable()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.toDoTable.reloadData()
        }
    }
    
}



class ToDoNavigationController: UINavigationController {
    override func viewDidLoad() {
        print("Loaded")
        self.navigationBar.backgroundColor = .red
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .red
    }
}

