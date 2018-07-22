//
//  CategoryModel.swift
//  Trip Plan
//
//  Created by Scarlet on 22/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class CategoryModel: NSObject {
    
    var Category_ID : String?
    var Category : String?
    
    override init(){
        
    }
    
    init(Category_ID : String, Category : String){
        self.Category_ID = Category_ID
        self.Category = Category
    }
    
    override var description: String {
        return "Category_ID: \(Category_ID), Category: \(Category)"
    }

}
