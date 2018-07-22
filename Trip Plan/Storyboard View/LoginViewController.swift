//
//  LoginViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, UITextFieldDelegate, LoginActionProtocol {

    var feedItems: LoginModel = LoginModel()
    
    @IBOutlet weak var navLogin: UINavigationItem!
    
    func itemsDownloaded(items: NSArray) {
        
        if items.count != 0 {
        
            feedItems = items.firstObject as! LoginModel
        
            let name: String = feedItems.S_Name!
        
        
            let alert = UIAlertController(title: "Welcome \(name)", message: "You are logged in.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.dismiss(animated: true, completion: {()->Void in
                        
                    });
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Cannot Login", message: "Email/ Password incorrect", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func postDownloaded(items: NSArray) {
        feedItems = items.firstObject as! LoginModel
    }
    
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 2
        }else{
            return 1
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    @IBAction func btnNoLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.delegate = self
        txtPassword.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func login(_ sender: UIButton) {
        
        Login()
        
    }
    
    @IBAction func loginBtn(_ sender: UIBarButtonItem) {
        
        Login()
        
    }
    
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        navLogin.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKB))
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        navLogin.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(Login))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    @objc func dismissKB(){
        view.endEditing(true)
        navLogin.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(Login))
    }
    
    @objc func Login(){
        
        let email: String = self.txtEmail.text!
        let password: String = self.txtPassword.text!
        
        if email.isEmpty || password.isEmpty {
            
            let alert = UIAlertController(title: "Cannot Login", message: "Email/ Password cannot be empty!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            let loginModel = LoginActionModel()
            loginModel.delegate = self
            loginModel.urlPath = "https://triplan.scarletsc.net/iOS/login.php?email=\(email)&password=\(password)"
            loginModel.downloadItems()
            
        }
        
    }
    
    @IBAction func loginViewTap(_ sender: UITapGestureRecognizer) {
        dismissKB()
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
