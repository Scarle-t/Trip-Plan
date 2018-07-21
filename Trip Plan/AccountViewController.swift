//
//  AccountViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var accountTableView: UITableView!
    
    var feedItems = Session.sharedInstance.loadArray()
    var selectedItem : String = ""
    var selectedValue : String = ""
    
    var itemDesc = ["User ID", "First Name", "Last Name", "Middle Name", "phone", "Area Code", "Gender", "Description", "Hobby", "Date of Birth", "Profile Visibility", "Join Date"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item = itemDesc[indexPath.row]
        // Get references to labels of cell
            myCell.textLabel!.text = item
            
            return myCell
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
        selectedItem = itemDesc[indexPath.row]
        selectedValue = feedItems[indexPath.row] as! String
        
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "accountDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC = segue.destination as! AccountDetailViewController
        
        detailVC.selectedItem = selectedItem
        detailVC.selectedValue = selectedValue
        detailVC.userID = feedItems.firstObject as? String
        
    }
    
    
    var loginModel = Session.sharedInstance.loadDatas()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
        
        if loginModel.M_Name != nil{
            self.title = loginModel.S_Name! + " " + loginModel.M_Name! + " " + loginModel.G_Name!
        }else{
            self.title = loginModel.S_Name! + " " + loginModel.G_Name!
        }
       
        self.accountTableView.reloadData()
        
        print(feedItems.count)
        
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
