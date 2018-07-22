//
//  AccountDetailViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 25/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class AccountDetailViewController: UIViewController, UITextFieldDelegate {
    
    var selectedItem : String?
    var selectedValue : String?
    var userID : String?
    
    @IBOutlet weak var lblCurrentValue: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = selectedItem
        self.lblCurrentValue.text = selectedValue
        
        if selectedItem != "User ID" || selectedItem != "Join Date"{
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }else{
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
         self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
        if(self.isEditing)
        {
            self.navigationItem.rightBarButtonItem?.title = "Cancel"
            lblCurrentValue.isEnabled = true
            lblCurrentValue.becomeFirstResponder()
        }else
        {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            lblCurrentValue.isEnabled = false
            view.endEditing(true)
        }
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.title = "Done"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let alert = UIAlertController(title: "New Value", message: "\(self.lblCurrentValue.text)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.view.endEditing(true)
                self.lblCurrentValue.isEnabled = false
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        
        
        
        
        self.present(alert, animated: true, completion: nil)
        
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
