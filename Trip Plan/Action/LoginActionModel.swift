//
//  LoginActionModel.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

protocol LoginActionProtocol: class{
    func itemsDownloaded(items: NSArray)
    func postDownloaded(items: NSArray)
}

class LoginActionModel: NSObject {
    
    //properties
    
    weak var delegate: LoginActionProtocol!
    
    var data = Data()
    
    var db :SQLiteConnect?
    
    let login = Session.sharedInstance.loadDatas()
    
    var urlPath: String = "" //this will be changed to the path where service.php lives
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let loginObj = NSMutableArray()
        
        let loginArray = Session.sharedInstance.loadArray()
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
        
        print(sqlitePath)
        
        db = SQLiteConnect(path: sqlitePath)
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            //the following insures none of the JsonElement values are nil through optional binding
            
            if let User_ID = jsonElement["User_ID"] as? Int,
                let S_Name = jsonElement["S_Name"] as? String,
                let G_Name = jsonElement["G_Name"] as? String
            {
                login.User_ID = "\(User_ID)"
                loginArray.add("\(User_ID)")
                login.S_Name = S_Name
                loginArray.add(S_Name)
                login.G_Name = G_Name
                loginArray.add(G_Name)
                if let M_Name = jsonElement["M_Name"] as? String{
                    login.M_Name = M_Name
                    loginArray.add(M_Name)
                }else{
                    loginArray.add("")
                }
                if let phone = jsonElement["phone"] as? Int{
                    login.phone = "\(phone)"
                    loginArray.add("\(phone)")
                }else{
                    loginArray.add("")
                }
                if let Area_Code = jsonElement["Area_Code"] as? Int{
                    login.Area_Code = "\(Area_Code)"
                    loginArray.add("\(Area_Code)")
                }else{
                    loginArray.add("")
                }
                if let gender = jsonElement["gender"] as? String{
                    login.gender = gender
                    loginArray.add(gender)
                }else{
                    loginArray.add("")
                }
                if let Description = jsonElement["Description"] as? String{
                    login.Description = Description
                    loginArray.add(Description)
                }else{
                    loginArray.add("")
                }
                if let Hobby = jsonElement["Hobby"] as? String{
                    login.Hobby = Hobby
                    loginArray.add(Hobby)
                }else{
                    loginArray.add("")
                }
                if let dob = jsonElement["dob"] as? String{
                    login.dob = dob
                    loginArray.add(dob)
                }else{
                    loginArray.add("")
                }
                if let Allow_Public = jsonElement["Allow_Public"] as? Int{
                    login.Allow_Public = "\(Allow_Public)"
                    loginArray.add("\(Allow_Public)")
                }else{
                    loginArray.add("")
                }
                if let icon = jsonElement["icon"] as? String{
                    login.icon = icon
                    loginArray.add(icon)
                }else{
                    loginArray.add("")
                }
                if let join_date = jsonElement["join_date"] as? String{
                    login.join_date = join_date
                    loginArray.add(join_date)
                }else{
                    loginArray.add("")
                }
                login.setStatus(status: true)
                
                if let mydb = db {
                    // insert
                    let _ = mydb.insert("user", rowInfo: ["User_ID":"'\(loginArray[0])'","S_Name":"'\(loginArray[1])'","G_Name":"'\(loginArray[2])'","M_Name":"'\(loginArray[3])'","phone":"'\(loginArray[4])'","Area_code":"'\(loginArray[5])'","gender":"'\(loginArray[6])'","description":"'\(loginArray[7])'","hobby":"'\(loginArray[8])'","dob":"'\(loginArray[9])'","Allow_public":"'\(loginArray[10])'","icon":"'\(loginArray[10])'","join_date":"'\(loginArray[12])'"])
                }
                
            }
            
            
            
            loginObj.add(login)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: loginObj)
            
        })
    }
    
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                
                print("Failed to download data")
                
            }else {
                print("Data downloaded")
                
                self.parseJSON(data!)
                
                
            }
            
        }
        
        task.resume()
        
    }
    
}
