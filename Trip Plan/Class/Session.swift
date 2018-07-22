//
//  Session.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//
import Foundation

class Session {
    
    //Singleton
    static let sharedInstance = Session()
    
    //Token which you assign and you can use through out application
    var token : LoginModel? = LoginModel()
    var loginArray : NSMutableArray = NSMutableArray()
    var catArray : NSMutableArray = NSMutableArray()
    
    func loadDatas() -> LoginModel {
        return token!
    }
    
    func loadArray() -> NSMutableArray {
        return loginArray
    }
    
    func loadCat() ->NSMutableArray{
        return catArray
    }
    
    func clearLogin(){
        token = LoginModel()
    }
    
}
