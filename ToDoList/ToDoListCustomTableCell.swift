//
//  ToDoListCustomTableCell.swift
//  ToDoList
//
//  Created by Keerthika Priya on 24/04/21.
//

import UIKit

protocol ToDoListCellDelegate: NSObjectProtocol {
    func didChangeTask(cell: ToDoListCustomTableCell)
    func didCompleteTask(completed: Bool,cell: ToDoListCustomTableCell)
}


class ToDoListCustomTableCell: UITableViewCell {
    let checkBox = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    let task = UITextField.init()
    weak var delegate: ToDoListCellDelegate?
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?,showCheckBox: Int, font: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell(showCheckBox: showCheckBox,font: font)
    }
    
    func setUpCell(showCheckBox: Int,font: String) {
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(checkBox)
        var checkBoxHt:CGFloat = 0
        var checkBoxColor = UIColor.gray
        if showCheckBox != 0 {
            checkBoxHt = 20
            checkBoxColor = showCheckBox == 1 ? UIColor.white : UIColor(red: 241.0/255.0, green: 176.0/255.0, blue: 163.0/255.0, alpha:1.0)
        }
        checkBox.isSelected = (showCheckBox == 2)
        checkBox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 10).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: checkBoxHt).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: checkBoxHt).isActive = true
//            checkBox.addCircle(color: UIColor(red: 255.0/255.0, green: 201.0/255.0, blue: 238.0/255.0, alpha:1.0), radius: 12)
        self.contentView.addSubview(task)
        task.translatesAutoresizingMaskIntoConstraints = false
        task.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 10).isActive = true
        
        task.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -10).isActive = true
        task.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        checkBox.addCircle(color: checkBoxColor,borderColor: showCheckBox == 1 ? .black : UIColor(red: 245/255, green: 52/255, blue: 0, alpha: 1.0), radius: checkBoxHt/2)
        checkBox.layer.cornerRadius = checkBoxHt/2
        checkBox.addShadow(color: UIColor(red: 255.0/255.0, green: 222.0/255.0, blue: 245.0/255.0, alpha:1.0))
        checkBox.addTarget(self, action: #selector(didSelectCheckBox(button:)), for: .touchUpInside)
//        checkBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCheckBox(button:))))
        self.backgroundColor = UIColor.white
        
    }
    
    func setFont(font: String) {
        self.task.attributedText = NSAttributedString(string: self.task.text ?? "", attributes: [.font: UIFont(name: font, size: 15)!])
    }
    
    func setTask(userTask: String,font: String) {
        task.attributedText = NSAttributedString(string: userTask, attributes: [.foregroundColor: UIColor.lightGray,.font:UIFont.init(name: font, size: 15)!])
    }
    
    @objc func didSelectCheckBox(button: UIButton) {
//        button.isSelected ? checkBox.addCircle(color: .white, radius: 10) : checkBox.addCircle(color: UIColor(red: 241.0/255.0, green: 176.0/255.0, blue: 163.0/255.0, alpha:1.0), borderColor: UIColor(red: 244, green: 55, blue: 4, alpha: 1.0),radius: 10)
        delegate?.didCompleteTask(completed: !button.isSelected, cell: self)
        button.isSelected = !button.isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}



extension UIView {
    
    func addCircle(color: UIColor, borderColor: UIColor = .black, radius: CGFloat, borderWidth : CGFloat = 0.5) {
        let circle = UIBezierPath.init(arcCenter: CGPoint(x: bounds.size.width/2 ,y: bounds.size.height/2), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: false)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circle.cgPath
            shapeLayer.fillColor = color.cgColor // UIColor(red: 255.0/255.0, green: 201.0/255.0, blue: 238.0/255.0, alpha:1.0).cgColor
        shapeLayer.strokeColor = borderColor.cgColor
//        shapeLayer.s
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func addShadow(color: UIColor) {
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
    }
    
}
