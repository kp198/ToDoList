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
    var shouldStrikeThrough = false
    var userFontName = fontName.AmericanTypewriter.rawValue
    var profileImage: UIImage?
    var userName = "User Name"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceLock()
        self.toDoTable.tableFooterView = UIView()
        toDoList = ["Build the app", "Test the app"]
        userName = UserDefaults.standard.value(forKey: "userName") as? String ?? "User Name"
        if let imageData = UserDefaults.standard.value(forKey: "profilePic") as? Data {
            profileImage = UIImage(data: imageData)
        }
        setUpFont()
        setUpToDoList()
        self.setProfileImage()
        setUpAddNewButton()
        (self.navigationController as? ToDoNavigationController)?.navDelegate = self
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
    
    func showAddTask(index: Int? = nil,text: String? = nil) {
        let taskView = NewTaskViewController.init(taskNum: index, text: text, delegate: self)
        self.present(taskView, animated: true, completion: nil)
    }
    
    func checkDeviceLock(){
    if let passCodeSet = UserDefaults.standard.value(forKey: "passCode") as? String {
        let passCodeView =  LoginPassCodeViewController.init(passCode: passCodeSet)
        passCodeView.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(passCodeView, animated: true, completion: nil)
        }
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
        cell.setTask(userTask: toDoList[indexPath.row], font: userFontName, shouldStrike: shouldStrikeThrough ? isTaskCompleted(index: indexPath.row) : false)
        cell.selectionStyle = .none
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
        return [.init(style: .destructive, title: "Delete", handler: {_,_ in
            self.deleteTask(row: indexPath.row)
            
        }), .init(style: .normal, title: "Edit", handler: {_,_ in
            self.showAddTask(index: indexPath.row,text: self.toDoList[indexPath.row])
        })]
    }
    
    func isTaskCompleted(index: Int) -> Bool {
        return toDoList.count - index - 1 < completedTaskCount ? true : false
    }
    
    func deleteTask(row: Int) {
        self.toDoList.remove(at: row)
        if self.isTaskCompleted(index: row) {
            self.completedTaskCount -= 1
        }
        self.reloadTable()
    }
}

//MARK: - Settings Delegate
extension ViewController: SettingsDelegate {
    
    func getStrikeThroughState() -> Bool {
        return shouldStrike()
    }
    
    func strikeThroughStateChanged(val: Bool) {
        UserDefaults.standard.set(val, forKey: "shouldStrike")
        self.shouldStrikeThrough = val
        self.reloadTable()
    }
    
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
    
    func shouldStrike() -> Bool {
        return shouldStrikeThrough
    }
    
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

//MARK: - New Task Delegate

extension ViewController: NewTaskDelegate {
    func addTask(task: String) {
        self.toDoList.insert(task, at: 0)
        self.reloadTable()
    }
    
    func getFontName() -> String {
       return self.userFontName
    }
    
    func deleteTask(taskNum: Int?) {
        guard let _ = taskNum else {
            return
        }
        self.deleteTask(row: taskNum!)
        reloadTable()
    }
    
    func copyTask(taskNum: Int?) {
        guard let _ = taskNum else {
            return
        }
        toDoList.append(toDoList[taskNum!])
        reloadTable()
    }
    
    func editTask(taskNum: Int?,task: String) {
        guard let _ = taskNum else {
            return
        }
        toDoList[taskNum!] = task
        self.reloadTable()
    }
}

//MARK:- Accounts Delegate

extension ViewController: AccountsDelegate {
    func setUserName(name: String) {
        UserDefaults.standard.setValue(name, forKey: "userName")
        setProfileImage()
        self.userName = name
    }
    
    func setProfileImage(image: UIImage) {
        UserDefaults.standard.setValue(image.jpegData(compressionQuality: 1.0), forKey: "profilePic")
        profileImage = image
        (self.navigationController as? ToDoNavigationController)?.setImageInButton(image: image)
    }
    
    func getProfileImage() -> UIImage? {
        return profileImage
    }
    
    func getUserName() -> String {
       return userName
    }
    
    func setProfileImage() {
        guard let image = profileImage else {
            guard let char = userName.first else {
                return
            }
            (self.navigationController as? ToDoNavigationController)?.setTitle(title: String(char))
            return
        }
        (self.navigationController as? ToDoNavigationController)?.setImageInButton(image: image)
    }
}

extension ViewController: ToDoNavigationDelegate {
    func settingsButtonTapped() {
        let settingsView = SettingsViewController.init()
        settingsView.delegate = self
        let navCont = UINavigationController(rootViewController: settingsView)
        self.present(navCont, animated: true, completion: nil)
    }
}
