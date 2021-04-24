//
//  FontViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit

protocol FontsDelegate : NSObjectProtocol {
    func chosenFont(font: String,index: Int)
    func selectedFont() -> Int
}

class FontViewController: UIViewController {
    
    let fontTable = UITableView.init(frame: .zero)
    weak var delegate : FontsDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationItem.title = "Font List"
        self.navigationItem.title = "Font List"
        setUpFontTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setUpFontTable() {
        self.view.addSubview(fontTable)
        fontTable.translatesAutoresizingMaskIntoConstraints = false
        fontTable.delegate = self
        fontTable.dataSource = self
        fontTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        fontTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        if #available(iOS 11.0, *) {
        fontTable.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        fontTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            fontTable.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
            fontTable.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor).isActive = true
        }
    }
}

extension FontViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontName.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.attributedText = NSAttributedString(string: fontName.allCases[indexPath.row].rawValue, attributes: [.foregroundColor: UIColor.darkText, .font: UIFont(name: fontName.allCases[indexPath.row].rawValue, size: 14)!] )
        if delegate?.selectedFont() == indexPath.row {
            let accesory = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            accesory.addCircle(color: UIColor.init(red: 255/255, green: 57/255, blue: 4/255, alpha: 1.0),borderColor: UIColor.init(red: 216/255, green: 52/255, blue: 8/255, alpha: 1.0), radius: 10)
            cell.accessoryView = accesory
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: {
            self.delegate?.chosenFont(font: fontName.allCases[indexPath.row].rawValue, index: indexPath.row)
        })
    }
}

