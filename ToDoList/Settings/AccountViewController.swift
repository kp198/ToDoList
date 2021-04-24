//
//  AccountViewController.swift
//  ToDoList
//
//  Created by Keerthika Priya on 25/04/21.
//

import UIKit
import Photos

class AccountViewController: UIViewController, UINavigationControllerDelegate {
    
    let accountInfo = ["Profile Image","Name"]
    let accountsTable = UITableView.init()
    let profileImage = UIButton.init()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccountsPage()
    }
    
    func setAccountsPage() {
        self.view.backgroundColor = .white
        self.view.addSubview(accountsTable)
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        self.accountsTable.backgroundColor = .white
        accountsTable.delegate = self
        accountsTable.dataSource = self
        accountsTable.setUpStandardTable(viewController: self)
    }
    
    func setProfileImage(letter: Character?) {
        guard let imageData = UserDefaults.standard.value(forKey: "profilePic") as? Data else {
            guard let char = letter else {
                return
            }
            profileImage.setTitle(String(char), for: .normal)
            return
        }
        profileImage.setImage(UIImage(data: imageData), for: .normal)
    }
    
    func setUpProfileImage(cell: UITableViewCell) {
        cell.contentView.addSubview(profileImage)
        profileImage.backgroundColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.layer.cornerRadius = 30
        profileImage.addTarget(self, action: #selector(chooseProfilePic), for: .touchUpInside)
    }
}

extension AccountViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1// accountInfo.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.backgroundColor = UIColor.white
        switch indexPath.section {
        case 0:
            self.setUpProfileImage(cell: cell)
        case 1:
            let nameField = UITextField.init()
            nameField.backgroundColor = .white
            cell.contentView.addSubview(nameField)
            nameField.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
            nameField.placeholder = "Type your name"
            nameField.text = UserDefaults.standard.value(forKey: "userName") as? String
            setProfileImage(letter: nameField.text?.first)
            nameField.delegate = self
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "USER NAME"
        default:
            break
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 48
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView.init()
//        header.
//        header.addSubview()
//        return header
//    }
    
    
}


extension AccountViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        UserDefaults.standard.setValue(text, forKey: "userName")
        self.setProfileImage(letter: text.first)
        
    }
    
}

extension AccountViewController: UIImagePickerControllerDelegate {
    
    @objc func chooseProfilePic() {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({
                status in
                if status == .authorized {
                    self.showPhotos()
                } else {
                    self.requestPermission()
                }
            })
        } else if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.showPhotos()
        } else {
            self.requestPermission()
        }
    }
    func showPhotos() {
        let photos = UIImagePickerController.init()
        photos.delegate = self
        self.present(photos, animated: true, completion: nil)
    }
    
    func requestPermission() {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Allow Access To Photos", message: "To Select a profile pic allow access to photos", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: {
            _ in
            UIApplication.shared.openURL( URL (string:UIApplication.openSettingsURLString)!)
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: {
            _ in
        }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.profileImage.setImage(image, for: .normal)
        
        UserDefaults.standard.setValue(image.jpegData(compressionQuality: 1.0), forKey: "profilePic")
        
    }
}
