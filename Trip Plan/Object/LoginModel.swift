//
//  LoginModel.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class LoginModel: NSObject {
    
    var User_ID : String?
    var S_Name : String?
    var M_Name : String?
    var G_Name : String?
    var phone : String?
    var Area_Code : String?
    var gender : String?
    var Description : String?
    var Hobby : String?
    var dob : String?
    var Allow_Public : String?
    var icon: String?
    var join_date : String?
    var status : Bool = false
    
    
    override init(){
        
    }
    
    init(User_ID : String, S_Name : String, M_Name : String, G_Name : String, phone : String, Area_Code : String, gender : String, Description : String, Hobby : String, dob : String, Allow_Public : String, icon : String, join_date : String){
        self.User_ID = User_ID
        self.S_Name = S_Name
        self.M_Name = M_Name
        self.G_Name = G_Name
        self.phone = phone
        self.Area_Code = Area_Code
        self.gender = gender
        self.Description = Description
        self.Hobby = Hobby
        self.dob = dob
        self.Allow_Public = Allow_Public
        self.icon = icon
        self.join_date = join_date
        
    }
    
    func isLoggedIn() -> Bool {
        return status
    }
    
    func setStatus(status: Bool){
        self.status = status
    }
    
    override var description: String {
        return "User_ID: \(User_ID), S_Name: \(S_Name), M_Name: \(M_Name), G_Name: \(G_Name), phone: \(phone), Area_Code: \(Area_Code), gender: \(gender), Description: \(Description), Hobby: \(Hobby), dob: \(dob), Allow_Public: \(Allow_Public), icon: \(icon), join_date: \(join_date)"
    }
    
}
