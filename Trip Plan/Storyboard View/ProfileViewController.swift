//
//  ProfileViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 26/7/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomeModelProtocol {
    
    let imgCache = NSCache<AnyObject, AnyObject>()
    let article = HomeModel()
    
    var userID: String?
    var userIcon: UIImage?
    var userName: String?
    var userDesc: String?
    var userDate: String?
    var feedItems: NSArray = NSArray()
    
    @IBOutlet weak var list: UICollectionView!
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        list.reloadData()
        
    }
    
    func postDownloaded(items: NSArray) {
        
        feedItems = items
        list.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TrendingCell
        
        let item = feedItems[indexPath.row] as! ArticleModel
        
        myCell.title.text = item.Title
        
        if let photo_path = item.media_path{
            
            let urlString = URL(string: "\(photo_path)")
            
            let url = URL(string: "\(photo_path)")
            
            if let imageFromCache = self.imgCache.object(forKey: url as AnyObject) as? UIImage{
                
                myCell.cover.image = imageFromCache
                
            }else{
                
                getDataFromUrl(url: url!) { data, response, error in
                    guard let imgData = data, error == nil else { return }
                    print(url!)
                    print("Download Finished")
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        //tdoll.photo = UIImage(data: imgData)
                        
                        let imgToCache = UIImage(data: imgData)
                        
                        if urlString == url{
                            
                            myCell.cover.image = imgToCache
                            
                        }
                        
                        if let imginCache = imgToCache{
                            self.imgCache.setObject(imginCache, forKey: urlString as AnyObject)
                        }
                        
                    })
                }
            }
        }
        
        myCell.layer.borderWidth = 1
        myCell.layer.borderColor = UIColor.lightGray.cgColor
        
        myCell.postID = item.Article_ID
        myCell.parent = self
        
        return myCell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor(white: 0, alpha: 0.5).cgColor
        
        let gl = CAGradientLayer()
        
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.3, 1.0]
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! ProfileCollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableView.profilePic.image = userIcon
            reusableView.profileName.text = userName!
            reusableView.profileDesc.text = userDesc!
            reusableView.profileDate.text = "Member since " + userDate!
            
            if let frame = UIApplication.shared.keyWindow?.frame{
                
                gl.frame = CGRect(x: 0, y: 0, width: frame.width, height: reusableView.profilePic.frame.height)
                
            }
            
            reusableView.profilePic.layer.insertSublayer(gl, at: 0)
            
        }
        
        return reusableView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! ProfileCollectionReusableView
        
        if elementKind == UICollectionElementKindSectionHeader {
         
            reusableView.profilePic.layer.insertSublayer(CALayer(), at: 0)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        list.delegate = self
        list.dataSource = self
        
        userDesc = Session.sharedInstance.loadDatas().Description
        userDate = Session.sharedInstance.loadDatas().join_date
        
        article.delegate = self
        guard let id = userID else {return}
        article.urlPath = "https://triplan.scarletsc.net/iOS/profile.php?id=\(id)"
        article.downloadItems()
        list.reloadData()
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    @IBAction func dismis(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get reference to the destination view controller
        
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.list.indexPath(for: sender)
            
            let selectedArticle = feedItems[(indexPath?.row)!] as! ArticleModel
            
            let detailVC  = segue.destination as! DetailViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            
            detailVC.selectedArticle = selectedArticle
            
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
