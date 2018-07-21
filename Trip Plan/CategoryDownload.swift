//
//  CategoryDownload.swift
//  Trip Plan
//
//  Created by Scarlet on 22/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

protocol CategoryDownloadProtocol: class {
    func itemsDownloaded(items: NSArray)
    func postDownloaded(items: NSArray)
}

class CategoryDownload: NSObject, URLSessionDataDelegate {
    
    weak var delegate: CategoryDownloadProtocol!
    
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
        let categories = NSMutableArray()
        
        let catArray = Session.sharedInstance.loadCat()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let category = CategoryModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            
            if let Category_ID = jsonElement["Category_ID"] as? Int{
                category.Category_ID = "\(Category_ID)"
            }
            
            
            if let Category = jsonElement["Category"] as? String
            {
                
                category.Category = Category
                catArray.add(Category)
                
            }
            
            categories.add(category)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: categories)
            
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
