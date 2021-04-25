//
//  SwiftExtensions.swift
//  ToDoList
//
//  Created by Keerthika Priya on 25/04/21.
//

import UIKit

extension UITableView {
    func setUpStandardTable(viewController: UIViewController) {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0,*) {
            self.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor).isActive = true
        }
        self.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: 0).isActive = true
    }
}


extension NSAttributedString {
    func setAttributedText(string: String? = nil,font: String?,color: UIColor? = nil,size: CGFloat?) -> NSAttributedString {
        
        return NSAttributedString(string: string ?? self.string, attributes: [.font: UIFont(name: font ?? fontName.TimesNewRomanPSMT.rawValue, size: size ?? 14)!,.foregroundColor: color ?? UIColor.black])
    }
    
    func setAttributedText(string: String? = nil,font: String?,color: UIColor? = nil,size: CGFloat?,strikeThroughStyle: Int?,strikeColor: UIColor? = nil) -> NSAttributedString {

        return NSAttributedString(string: string ?? self.string, attributes: [.font: UIFont(name: font ?? fontName.TimesNewRomanPSMT.rawValue, size: size ?? 14)!,.foregroundColor: color ?? UIColor.black,.strikethroughStyle: strikeThroughStyle ?? NSUnderlineStyle.single.rawValue,.strikethroughColor:strikeColor ?? UIColor.black])
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


extension UITextField {
    func isEmpty() -> Bool {
        return self.text == nil || self.text == ""
    }
}

extension UIImage {
    func cropImage(rect: CGRect, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width/scale, height: rect.size.height/scale), true, 0.0)
        self.draw(at: CGPoint(x: -rect.origin.x/scale, y: -rect.origin.y/scale))
        let cropImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cropImage
    }
}
