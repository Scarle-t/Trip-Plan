//
//  CategoryItemDownload.swift
//  Trip Plan
//
//  Created by Scarlet on 22/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

protocol CategoryItemDownloadProtocol: class{
    func itemsDownloaded(items: NSArray)
    func postDownloaded(items: NSArray)
}

class CategoryItemDownload: NSObject, URLSessionDataDelegate {
    
    weak var delegate: CategoryItemDownloadProtocol!
    
    var data = Data()
    
    var urlPath: String = "" //this will be changed to the path where service.php lives
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let articles = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let article = ArticleModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            
            if let User_ID = jsonElement["User_ID"] as? Int{
                article.User_ID = "\(User_ID)"
            }
            
            
            if let S_Name = jsonElement["S_Name"] as? String
            {
                
                article.S_Name = S_Name
                
            }
            
            if let G_Name = jsonElement["G_Name"] as? String
            {
                
                article.G_Name = G_Name
                
            }
            
            if let M_Name = jsonElement["M_Name"] as? String
            {
                
                article.M_Name = M_Name
                
            }
            
            if let phone = jsonElement["phone"] as? Int
            {
                
                article.phone = "\(phone)"
                
            }
            
            if let Area_Code = jsonElement["Area_Code"] as? Int
            {
                
                article.Area_Code = "\(Area_Code)"
                
            }
            
            if let gender = jsonElement["gender"] as? String
            {
                
                article.gender = gender
                
            }
            
            if let Description = jsonElement["Description"] as? String
            {
                
                article.Description = Description
                
            }
            
            if let Hobby = jsonElement["Hobby"] as? String
            {
                
                article.Hobby = Hobby
                
            }
            
            if let dob = jsonElement["dob"] as? String
            {
                
                article.dob = dob
                
            }
            
            if let Allow_Public = jsonElement["Allow_Public"] as? Int
            {
                
                article.Allow_Public = "\(Allow_Public)"
                
            }
            
            if let icon = jsonElement["icon"] as? String
            {
                article.icon = icon
            }
            
            if let join_date = jsonElement["join_date"] as? String
            {
                
                article.join_date = join_date
                
            }
            
            if let Article_ID = jsonElement["Article_ID"] as? Int
            {
                
                article.Article_ID = "\(Article_ID)"
                
            }
            
            if let Title = jsonElement["Title"] as? String
            {
                
                article.Title = Title
                
            }
            
            if let Content = jsonElement["Content"] as? String
            {
                
                article.Content = Content
                
            }
            
            if let type = jsonElement["type"] as? String
            {
                
                article.type = type
                
            }
            
            if let Timestamp = jsonElement["Timestamp"] as? String
            {
                
                article.Timestamp = Timestamp
                
            }
            
            if let Post_Date = jsonElement["Post_Date"] as? String
            {
                
                article.Post_Date = Post_Date
                
            }
            
            if let address = jsonElement["address"] as? String
            {
                
                article.address = address
                
            }
            
            if let media_path = jsonElement["media_path"] as? String
            {
                
                article.media_path = "https://triplan.scarletsc.net/uploads/img/\(media_path)"
                
            }
            
            articles.add(article)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: articles)
            
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
