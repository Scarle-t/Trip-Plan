//
//  RegisterViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 29/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, regActionProtocol {
    
    func reg(status: String) {
        if status == "true" {
            
            let alert = UIAlertController(title: "Welcome to Trip Plan!", message: "You can now login", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if status == "exist"{
            let alert = UIAlertController(title: "Email already exist.", message: "", preferredStyle: UIAlertController.Style.alert)
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
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtVerify: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapDismissKb(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func btnReg(_ sender: UIBarButtonItem) {
        
        let reg = regAction()
        reg.delegate = self
        
        let userid = "\(arc4random_uniform(9))\(Calendar.current.component(.day, from: Date()))\(Calendar.current.component(.hour, from: Date()))\(Calendar.current.component(.second, from: Date()))\(arc4random_uniform(9))"
        
        if let email = txtEmail.text,
           let pass = txtPass.text,
           let verify = txtVerify.text,
           let fname = txtFname.text,
           let lname = txtLname.text{
            
            if pass == verify{
                reg.urlPath = "https://triplan.scarletsc.net/iOS/register.php?id=\(userid)&email=\(email)&pass=\(pass)&fname=\(fname)&lname=\(lname)"
                reg.downloadItems()
                
            }else{
                let alert = UIAlertController(title: "Password does not match", message: "Please enter the same Password", preferredStyle: UIAlertController.Style.alert)
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
