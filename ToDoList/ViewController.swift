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
    var completedTaskCount = 0
    var fontIndex = 0
    var userFontName = fontName.AmericanTypewriter.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoList = ["Build the app", "Test the app"]
        setUpFont()
        setUpToDoList()
        setUpSettingsView()
        setUpAddNewButton()
        self.navigationItem.title = "To Do List"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        self.view.backgroundColor = UIColor.white
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
        toDoTable.backgroundColor = UIColor.white
        
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
    
    func setUpAddNewButton() {
        let addButton = UIButton()//UIButton(type: .contactAdd)
        addButton.setAttributedTitle(NSAttributedString(string: "+").setAttributedText( font: fontName.Copperplate_Bold.rawValue, color: .red, size: 40), for: .normal)
        addButton.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
        self.view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -20).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.layer.cornerRadius = 30
        if #available(iOS 11.0, *) {
            addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -30).isActive = true
        } else {
            addButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -30).isActive = true
        }
        addButton.backgroundColor = .white
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = .zero
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 2.0
        view.bringSubviewToFront(addButton)
    }
    
    @objc func addNewTask() {
        showAddTask()
    }
    
    func showAddTask(text: String? = nil) {
        let taskView = NewTaskViewController.init(text: text, delegate: self)
        self.present(taskView, animated: true, completion: nil)
    }

}


//MARK: - TableView
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ToDoListCustomTableCell(style: .default, reuseIdentifier: "cell", showCheckBox: isTaskCompleted(index: indexPath.row) ? 2 : 1 ,font: userFontName)
        cell.delegate = self
        cell.setTask(userTask: toDoList[indexPath.row],font: userFontName)
        cell.selectionStyle = .none
//        cell.setFont(font: userFontName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [.init(style: .destructive, title: "Delete", handler: {a,b in
            self.toDoList.remove(at: indexPath.row)
            if self.isTaskCompleted(index: indexPath.row) {
                self.completedTaskCount -= 1
            }
            self.reloadTable()
        }), .init(style: .normal, title: "Edit", handler: {_,_ in
            self.showAddTask(text: self.toDoList[indexPath.row])
        })]
    }
    
    func isTaskCompleted(index: Int) -> Bool {
        return toDoList.count - index - 1 < completedTaskCount ? true : false
    }
}


extension ViewController: SettingsDelegate {
    func selectedFont() -> Int {
        return fontIndex
    }
    
    func chosenFont(font: String,index: Int) {
        self.userFontName = font
        self.fontIndex = index
        UserDefaults.standard.setValue(["fontName":font,"index":index], forKey: "userFont")
        reloadTable()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.toDoTable.reloadData()
        }
    }
    
}

//MARK: - Cell Delegate

extension ViewController: ToDoListCellDelegate {
    func didCompleteTask(completed: Bool, cell: ToDoListCustomTableCell) {
        guard let row = toDoTable.indexPath(for: cell)?.row else {
            return
        }
        if completed {
            toDoList.insert(toDoList[row], at: toDoList.count - completedTaskCount < 0 ? toDoList.count - 1 : toDoList.count - completedTaskCount)
            toDoList.remove(at: row)
            completedTaskCount += 1
            reloadTable()
        } else {
            completedTaskCount -= 1
            toDoList.insert(toDoList[row], at: toDoList.count - completedTaskCount < 0 ? 0 : toDoList.count - completedTaskCount - 1)
            toDoList.remove(at: row + 1)
            reloadTable()
        }
    }
    
    func didChangeTask(cell: ToDoListCustomTableCell) {
        if let index = self.toDoTable.indexPath(for: cell) {
            toDoList[index.row] = cell.task.text ?? toDoList[index.row]
        }
    }
}

extension ViewController: NewTaskDelegate {
    func addTask(task: String) {
        self.toDoList.insert(task, at: 0)
        self.reloadTable()
    }
    
    func getFontName() -> String {
       return self.userFontName
    }
    
    func deleteTask(taskNum: Int) {
        
    }
    
    func copyTask(taskNum: Int) {
        
    }
    
    func editTask() {
        
    }
    
    
}



class ToDoNavigationController: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.backgroundColor = .red
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .red
    }
}


extension NSAttributedString {
    func setAttributedText(font: String?,color: UIColor?,size: CGFloat?) -> NSAttributedString {
        
        return NSAttributedString(string: self.string, attributes: [.font: UIFont(name: font ?? fontName.TimesNewRomanPSMT.rawValue, size: size ?? 14)!,.foregroundColor: color ?? UIColor.black])
    }
}
