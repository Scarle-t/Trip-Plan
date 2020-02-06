//
//  ArticleModel.swift
//  Trip Plan
//
//  Created by Scarlet on 18/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class ArticleModel: NSObject {
    
    //properties
    
    var User_ID : String?
    var S_Name : String?
    var G_Name : String?
    var M_Name : String?
    var phone : String?
    var Area_Code : String?
    var gender : String?
    var Description : String?
    var Hobby : String?
    var dob : String?
    var Allow_Public : String?
    var icon : String?
    var join_date : String?
    var Article_ID : String?
    var Title : String?
    var Content : String?
    var type : String?
    var Timestamp : String?
    var Post_Date : String?
    var address : String?
    var media_path : String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(User_ID: String, S_Name: String, G_Name : String ,M_Name : String ,phone : String ,Area_Code : String ,gender : String ,Description : String ,Hobby : String ,dob : String ,Allow_Public : String ,icon : String, join_date : String ,Article_ID : String ,Title : String ,Content : String ,type : String ,Timestamp : String ,Post_Date : String ,address : String, media_path: String) {
        
        self.User_ID = User_ID
        self.S_Name = S_Name
        self.G_Name = G_Name
        self.M_Name = M_Name
        self.phone = phone
        self.Area_Code = Area_Code
        self.gender = gender
        self.Description = Description
        self.Hobby = Hobby
        self.dob = dob
        self.Allow_Public = Allow_Public
        self.icon = icon
        self.join_date = join_date
        self.Article_ID = Article_ID
        self.Title = Title
        self.Content = Content
        self.type = type
        self.Timestamp = Timestamp
        self.Post_Date = Post_Date
        self.address = address
        self.media_path = media_path
        
        
    }
    
    //prints object's current state
    
    override var description: String {
        return "User_ID: \(User_ID), S_Name: \(S_Name), G_Name: \(G_Name), M_Name: \(M_Name), phone: \(phone), Area_Code: \(Area_Code), gender: \(gender), Description: \(Description), Hobby: \(Hobby), dob: \(dob), Allow_Public: \(Allow_Public), join_date: \(join_date), Article_ID: \(Article_ID), Title: \(Title), Content: \(Content), type: \(type), Timestamp: \(Timestamp), Post_Date: \(Post_Date), address: \(address), media_path: \(media_path)"
        
    }
}
