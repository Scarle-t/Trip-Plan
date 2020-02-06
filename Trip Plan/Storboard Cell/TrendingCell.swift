//
//  TrendingCell.swift
//  Trip Plan
//
//  Created by Scarlet on 20/5/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class TrendingCell: UICollectionViewCell, deleteProtocol {
    
    @IBOutlet weak var title: UITextField!
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var more_btn: UIButton!
    
    @IBOutlet weak var dimView: UIView!
    
    var parent: ProfileViewController?
    
    var postID: String?
    
    func deleted(status: Bool) {
        
        guard let source = parent else {return}
        
        if status{
            
            let alert = UIAlertController(title: "Deleted", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    source.article.downloadItems()
                    source.list.reloadData()
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            source.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            source.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func actionMenu(_ sender: UIButton) {
        
        if let source = parent, let post = postID{
            
            let alert = UIAlertController(title: "Are you sure you want to delete this post?", message: "", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    let delete = deletePost()
                    delete.delegate = self
                        delete.urlPath = "https://triplan.scarletsc.net/iOS/delete.php?id=\(post)"
                    
                    delete.downloadItems()
                    
                    
                }}))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            source.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
