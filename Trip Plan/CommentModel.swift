//
//  CommentModel.swift
//  Trip Plan
//
//  Created by Scarlet on 28/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    
    var comment: String?
    var S_Name: String?
    var G_Name: String?
    var M_Name: String?
    var cmt_Date: String?
    
    override init(){
        
    }
    
    init(comment: String, S_Name: String, M_Name: String, G_Name: String, cmt_Date: String){
        self.comment = comment
        self.S_Name = S_Name
        self.M_Name = M_Name
        self.G_Name = G_Name
        self.cmt_Date = cmt_Date
    }
    
    override var description: String{
        return "Comment: \(comment)"
    }

}
