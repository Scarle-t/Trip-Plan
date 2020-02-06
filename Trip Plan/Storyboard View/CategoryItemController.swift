//
//  CategoryItemController.swift
//  Trip Plan
//
//  Created by Scarlet on 22/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class CategoryItemController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CategoryItemDownloadProtocol {
    
    var feedItems: NSArray = NSArray()
    
    var selectedCategory : CategoryModel?
    
    var selectedArticle : ArticleModel = ArticleModel()
    
    @IBOutlet weak var listTableView: UICollectionView!
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func postDownloaded(items: NSArray) {
        feedItems = items
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return feedItems.count
        
    }
    
    let imgCache = NSCache<AnyObject, AnyObject>()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TrendingCell
        
        myCell.layer.borderWidth = 1
        myCell.layer.borderColor = UIColor.lightGray.cgColor
        
        // Get the location to be shown
        let item: ArticleModel = feedItems[indexPath.row] as! ArticleModel
        // Get references to labels of cell
        
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
        
        myCell.title.text = item.Title
        
        return myCell
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        let categoryItemDownload = CategoryItemDownload()
        categoryItemDownload.delegate = self
        categoryItemDownload.urlPath = "https://triplan.scarletsc.net/iOS/category_detail.php?catid=" + (self.selectedCategory?.Category_ID)!
        categoryItemDownload.downloadItems()
        
        self.listTableView.reloadData()
        refreshControl.endRefreshing()
        
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "Network Error", message: "Network Unavailable. \nFailed to download data.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    
                    self.dismiss(animated: true, completion: {()->Void in
                        
                    });
                    
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = self.selectedCategory?.Category
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let categoryItemDownload = CategoryItemDownload()
        categoryItemDownload.delegate = self
        categoryItemDownload.urlPath = "https://triplan.scarletsc.net/iOS/category_detail.php?catid=" + (self.selectedCategory?.Category_ID)!
        categoryItemDownload.downloadItems()
        
        self.listTableView.refreshControl = self.refreshControl
        
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "Network Error", message: "Network Unavailable. \nFailed to download data.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    
                    self.dismiss(animated: true, completion: {()->Void in
                        
                    });
                    
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get reference to the destination view controller
        
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.listTableView.indexPath(for: sender)
            
            selectedArticle = feedItems[(indexPath?.row)!] as! ArticleModel
            
        }
        
        let detailVC  = segue.destination as! DetailViewController
        // Set the property to the selected location so when the view for
        // detail view controller loads, it can access that property to get the feeditem obj
        
        detailVC.selectedArticle = selectedArticle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
