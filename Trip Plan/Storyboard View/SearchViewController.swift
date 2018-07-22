//
//  SearchViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, HomeModelProtocol {
    
    var feeditems : NSArray = NSArray()
    var selectedArticle : ArticleModel = ArticleModel()
    
    @IBOutlet weak var listTableView: UITableView!
    
    func itemsDownloaded(items: NSArray) {
        feeditems = items
        self.listTableView.reloadData()
    }
    
    func postDownloaded(items: NSArray) {
        feeditems = items
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeditems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: ArticleModel = feeditems[indexPath.row] as! ArticleModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.Title
        
        return myCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
     
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        
        if let q = searchController.searchBar.text?.replacingOccurrences(of: " ", with: "%20"){
            homeModel.urlPath = "https://triplan.scarletsc.net/iOS/search.php?q=\(q)"
        }
        
        homeModel.downloadItems()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected location to var
        selectedArticle = feeditems[indexPath.row] as! ArticleModel
        
        // Manually call segue to detail view controller
        self.performSegue(withIdentifier: "searchSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
            
            // Get reference to the destination view controller
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
