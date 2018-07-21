//
//  CommentDownload.swift
//  Trip Plan
//
//  Created by Scarlet on 28/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

protocol CommentDownloadProtocol: class{
    func itemsDownloaded(items: NSArray)
}

class CommentDownload: NSObject, URLSessionDataDelegate {
    
    weak var delegate: CommentDownloadProtocol!
    
    var data = Data()
    
    var urlPath: String = ""
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let comments = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let comment = CommentModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            
            
            if let cmt = jsonElement["Comment"] as? String
            {
                
                comment.comment = cmt
                
            }
            
            if let cmt_date = jsonElement["Cmt_Date"] as? String{
                
                comment.cmt_Date = cmt_date
                
            }
            
            if let S_name = jsonElement["S_Name"] as? String
            {
                
                comment.S_Name = S_name
                
            }else{
             comment.S_Name = ""
            }
            
            if let G_name = jsonElement["G_Name"] as? String
            {
                
                comment.G_Name = G_name
                
            }else{
                comment.G_Name = ""
            }
            
            if let M_name = jsonElement["M_Name"] as? String
            {
                
                comment.M_Name = M_name
                
            }else{
                comment.M_Name = ""
            }
            
            comments.add(comment)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: comments)
            
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
