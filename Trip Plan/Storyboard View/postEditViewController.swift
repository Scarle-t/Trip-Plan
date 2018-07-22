//
//  postEditViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 30/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class postEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeModelProtocol, deleteProtocol {
    
    func deleted(status: Bool) {
        
        if status{
            
            let alert = UIAlertController(title: "Deleted", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
            self.navigationController?.popToRootViewController(animated: true)
                    
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: ArticleModel = feedItems[indexPath.row] as! ArticleModel
        // Get references to labels of cell
        myCell.textLabel!.text = item.Title
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete this post?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
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
                if let postid = (self.feedItems[indexPath.row] as! ArticleModel).Article_ID {
                    delete.urlPath = "https://triplan.scarletsc.net/iOS/delete.php?id=\(postid)"
                }
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
        
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBOutlet weak var listTableView: UITableView!
    
    var feedItems: NSArray = NSArray()
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func postDownloaded(items: NSArray) {
        feedItems = items
    }
    
    
    
    let loginModel = Session.sharedInstance.loadDatas()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        let homeModel = HomeModel()
        homeModel.delegate = self
        if let userid = self.loginModel.User_ID{
            homeModel.urlPath = "https://triplan.scarletsc.net/iOS/editPost.php?id=\(userid)"
        }
        
        homeModel.downloadItems()
        
    
    }
    
    @IBAction func navDone(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
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
