//
//  deletePost.swift
//  Trip Plan
//
//  Created by Scarlet on 30/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

protocol deleteProtocol: class {
    func deleted(status: Bool)
}

class deletePost: NSObject, URLSessionDataDelegate {
    
    weak var delegate: deleteProtocol!
    
    var data = Data()
    
    var urlPath: String = ""
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        for _ in 0 ..< jsonResult.count
        {
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.delegate.deleted(status: true)
                
            })
        }
        
        
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
