//
//  CategoryViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 18/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CategoryDownloadProtocol  {
    
    var feedItems: NSArray = NSArray()
    var selectedCategory : CategoryModel = CategoryModel()
    
    let loginModel = Session.sharedInstance.loadDatas()
    
    var segueDest : String = ""
    
    @IBOutlet weak var listTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        let categoryModel = CategoryDownload()
        categoryModel.delegate = self
        categoryModel.urlPath = "https://triplan.scarletsc.net/iOS/category.php"
        categoryModel.downloadItems()
        
        self.listTableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set delegates and initialize homeModel
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let categoryModel = CategoryDownload()
        categoryModel.delegate = self
        categoryModel.urlPath = "https://triplan.scarletsc.net/iOS/category.php"
        categoryModel.downloadItems()
        
        self.listTableView.refreshControl = self.refreshControl

    }
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func postDownloaded(items: NSArray) {
        
        feedItems = items
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: CategoryModel = feedItems[indexPath.row] as! CategoryModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.Category
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
        selectedCategory = feedItems[indexPath.row] as! CategoryModel
        
        // Manually call segue to detail view controller
        self.segueDest = "detail"
        self.performSegue(withIdentifier: "CategorySegue", sender: self)
        
    }
    
    @IBAction func menuBtn(_ sender: UIBarButtonItem) {
        
        if loginModel.isLoggedIn(){
            
            Menu(self).show()
            
        }else{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as? UINavigationController
            {
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func slideMenu(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        if sender.state == .began{
            Menu(self).show()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueDest == "detail" {
            
            segueDest = ""
            
            // Get reference to the destination view controller
            let detailVC  = segue.destination as! CategoryItemController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            
            detailVC.selectedCategory = selectedCategory
        }
        
        if(segue.identifier == "postingSegue"){
            
            // Get reference to the destination view controller
            let detailVC  = segue.destination as! PostingViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            self.segueDest = ""
            detailVC.loginModel = loginModel
            
        }
        
        if(segue.identifier == "accountSegue"){
            
            
            
        }
       
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

