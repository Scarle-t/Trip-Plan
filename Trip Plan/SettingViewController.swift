//
//  SettingViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 25/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var db :SQLiteConnect?
    
    var loginModel = Session.sharedInstance.loadDatas()
    
    var loginArray = Session.sharedInstance.loadArray()
    
    var settingPanel = ["Account Settings", "Delete Posts",  "Logout"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPanel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item = settingPanel[indexPath.row]
        // Get references to labels of cell
        myCell.textLabel!.text = item
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
        
        
        // Manually call segue to detail view controller
        print(settingPanel[indexPath.row])
        
        if settingPanel[indexPath.row] == settingPanel.last {
            
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
                loginArray.removeAllObjects()
                loginModel.setStatus(status: false)
                let alert = UIAlertController(title: "You have been logged out!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        self.dismiss(animated: true, completion: {()->Void in
                            
                        });
                        
                    }}))
                
                self.present(alert, animated: true, completion: nil)
            }else{
                print(status)
            }
            
        }
        
        if settingPanel[indexPath.row] == settingPanel[0] {
            
            if let tabViewController = storyboard?.instantiateViewController(withIdentifier: "Account") as? UINavigationController {
                
                present(tabViewController, animated: true, completion: nil)
                
            }
            
        }
        
        if settingPanel[indexPath.row] == settingPanel[1] {
        
            if let tabViewController = storyboard?.instantiateViewController(withIdentifier: "editPost") as? UINavigationController {
                
                present(tabViewController, animated: true, completion: nil)
                
            }
        
        }
        
        
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
  
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        
        self.listTableView.reloadData()
        
    }

    @IBAction func navDone(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: {()->Void in
            
        });
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
