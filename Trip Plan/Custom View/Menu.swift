//
//  Menu.swift
//  Trip Plan
//
//  Created by Scarlet on 17/7/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class Menu: NSObject, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    let dimView = UIView()
    let header = UIView()
    let userImage = UIImageView()
    let userName = UILabel()
    let section = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    let closeBtn = UIButton()
    
    var settingPanel = [String]()
    var loginArray = Session.sharedInstance.loadArray()
    var loginModel: LoginModel?
    var db :SQLiteConnect?
    var mySelf: Menu?
    var status = false
    
    var parent: UIViewController?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settingPanel.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "BasicCell"
        let myCell = section.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        
        switch indexPath.section {
        case 0:
                myCell.textLabel?.text = settingPanel[indexPath.row]
        case 1:
            myCell.textLabel?.text = "Logout"
            myCell.textLabel?.textColor = UIColor(red: 1, green: 0.2196078431, blue: 0.137254902, alpha: 1)
        default:
            return myCell
        }
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                dismiss()
                if let nav = parent?.storyboard?.instantiateViewController(withIdentifier: "profile") as? UINavigationController, let view = nav.viewControllers.first as? ProfileViewController{
                    
                    view.userIcon = userImage.image
                    view.userName = userName.text
                    view.userID = Session.sharedInstance.loadDatas().User_ID
                    parent?.present(nav, animated: true, completion: nil)
                }
            case 1:
                dismiss()
                    if let tabViewController = parent?.storyboard?.instantiateViewController(withIdentifier: "Account") as? UINavigationController {
                        
                        parent?.present(tabViewController, animated: true, completion: nil)
                }
            default:
                break
            }
        case 1:
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
            print(sqlitePath)
            
            db = SQLiteConnect(path: sqlitePath)
            
            var status : Bool = false
            
            var id : String = ""
            
            if let mydb = db {
                
                let statement = mydb.fetch("user", cond: "User_ID != ''  ", order: nil)
                
                while sqlite3_step(statement) == SQLITE_ROW{
                    id = String(cString: sqlite3_column_text(statement, 0))
                }
                
                sqlite3_finalize(statement)
                status = mydb.delete("user", cond: "User_id = '\(id)'")
                
            }
            
            print(id)
            
            if status {
                
                let ask = UIAlertController(title: "Are you sure to logout?", message: "", preferredStyle: UIAlertController.Style.alert)
                ask.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                    }}))
                
                ask.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        self.loginArray.removeAllObjects()
                        self.loginModel?.setStatus(status: false)
                        let alert = UIAlertController(title: "You have been logged out!", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            }}))
                        
                        self.parent?.present(alert, animated: true, completion: nil)
                        
                    }}))
                
                dismiss()
                parent?.present(ask, animated: true, completion: nil)
                
            }else{
                print(status)
            }
        default:
            break
        }
    }
    
    func show(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.dimView.alpha = 1
            self.section.frame = CGRect(x: 0, y: 0, width: self.section.frame.width, height: self.section.frame.height)
        }, completion: nil)
    }
    
    func ready(){
        
        if status {
            
            if let M_name = loginModel?.M_Name{
                
                if let S_name = loginModel?.S_Name, let G_name = loginModel?.G_Name, let icon = loginModel?.icon{
                    
                        userName.text = S_name + " " + M_name + " " + G_name
                    
                    let url = URL(string: "https://triplan.scarletsc.net/img/icon/\(String(describing: icon))")
                    downloadImage(url: url!) { data, response, error in
                        guard let imgData = data, error == nil else { return }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.userImage.image = UIImage(data: imgData)
                        })
                    }
                    
                }
                
            }else{
                
                if let S_name = loginModel?.S_Name, let G_name = loginModel?.G_Name, let icon = loginModel?.icon{
                    
                        userName.text = S_name + " " + G_name
                    
                    let url = URL(string: "https://triplan.scarletsc.net/img/icon/\(String(describing: icon))")
                    downloadImage(url: url!) { data, response, error in
                        guard let imgData = data, error == nil else { return }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.userImage.image = UIImage(data: imgData)
                        })
                    }
                    
                }
                
            }
            
            settingPanel = ["Profile", "Account Settings"]
            
            section.delegate = self
            section.dataSource = self
            section.tableHeaderView = header
            section.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
            
            dimView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            section.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            
            dimView.alpha = 0
            
            closeBtn.setImage(UIImage(imageLiteralResourceName: "back"), for: .normal)
            closeBtn.addTarget(mySelf, action: #selector(dismiss), for: .touchUpInside)
            dimView.addGestureRecognizer(UITapGestureRecognizer(target: mySelf, action: #selector(dismiss)))
            
            let swipeDismiss = UISwipeGestureRecognizer(target: mySelf, action: #selector(dismiss))
            swipeDismiss.direction = .left
            dimView.addGestureRecognizer(swipeDismiss)
            section.addGestureRecognizer(swipeDismiss)
            
            if let window = UIApplication.shared.keyWindow{
                
                let xScale: CGFloat = 0.75
                //            let yScale: CGFloat = 1.0
                let yHeaderScale: CGFloat = 0.3
                let txtHeight: CGFloat = 30.0
                let imgWidth: CGFloat = 150.0
                
                dimView.frame = window.frame
                header.frame = CGRect(x: 0, y: 0, width: window.frame.width * xScale, height: window.frame.height * yHeaderScale)
                section.frame = CGRect(x: 0 - (window.frame.width * xScale), y: 0, width: window.frame.width * xScale, height: window.frame.height)
                userImage.frame = CGRect(x: (header.frame.width - imgWidth) / 2, y: 0, width: imgWidth, height: imgWidth)
                userName.frame = CGRect(x: 0, y: imgWidth + txtHeight, width: header.frame.width, height: txtHeight)
                userName.textAlignment = .center
                userName.font = UIFont.systemFont(ofSize: 25.0)
                closeBtn.frame = CGRect(x: 10, y: 0, width: txtHeight, height: txtHeight)
                
                closeBtn.isUserInteractionEnabled = true
                header.isUserInteractionEnabled = true
                section.isUserInteractionEnabled = true
                window.isUserInteractionEnabled = true
                
                window.addSubview(dimView)
                
                header.addSubview(userImage)
                header.addSubview(userName)
                
                window.addSubview(section)
                header.addSubview(closeBtn)
                
                print("subview added")
            }
            
            print("menu ready")
            
        }else{
            
            print("Not logged in")
            settingPanel.removeAll()
            
        }
    }
    
    @objc func dismiss(){
        print("dismiss")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.dimView.alpha = 0
            self.section.frame = CGRect(x: 0 - self.section.frame.width, y: 0, width: self.section.frame.width, height: self.section.frame.height)
        }, completion: nil)
    }
    
    func downloadImage(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    override init(){
        super.init()
        mySelf = self
        loginModel = Session.sharedInstance.loadDatas()
        status = (loginModel?.isLoggedIn())!
        ready()
    }
    
    init(_ parent: UIViewController){
        super.init()
        self.parent = parent
        mySelf = self
        loginModel = Session.sharedInstance.loadDatas()
        status = (loginModel?.isLoggedIn())!
        ready()
    }

}
