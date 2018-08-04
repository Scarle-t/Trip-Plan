//
//  TrendingCollectionViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 20/5/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class TrendingCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomeModelProtocol {
    
    @IBOutlet weak var listTableView: UICollectionView!
    
    var db: SQLiteConnect?
    
    var feedItems: NSArray = NSArray()
    var selectedArticle : ArticleModel = ArticleModel()
    
    let loginModel = Session.sharedInstance.loadDatas()
    
    var loginArray = Session.sharedInstance.loadArray()
    
    var urlPath : String = ""
    
    var segueDest : String = ""
    
    var data = Data()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        
        self.urlPath = "https://triplan.scarletsc.net/iOS/main.php"
        self.downloadItems()
        
        self.listTableView.reloadData()
        refreshControl.endRefreshing()
        
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "Network Error", message: "Network Unavailable. \nFailed to download data.", preferredStyle: UIAlertControllerStyle.alert)
            
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
            
            self.itemsDownloaded(items: articles)
            
            
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
        
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor(white: 0, alpha: 0.7).cgColor
        
        let gl = CAGradientLayer()
        
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.65, 1.0]
        
        myCell.dimView.backgroundColor = UIColor.clear
        gl.frame = myCell.dimView.frame
        
        myCell.dimView.layer.insertSublayer(gl, at: 0)
        
        return myCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TrendingCell
        
        myCell.dimView.layer.insertSublayer(CALayer(), at: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TrendingCell
        
        myCell.dimView.layer.insertSublayer(CALayer(), at: 0)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    @IBAction func slideMenu(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began{
            Menu(self).show()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
        
        print(sqlitePath)
        
        db = SQLiteConnect(path: sqlitePath)
        
        if let mydb = db {
            
            // create table
            let _ = mydb.createTable("user", columnsInfo: [
                "User_ID text primary key",
                "S_Name text",
                "G_Name text",
                "M_Name text",
                "phone text",
                "Area_code text",
                "gender text",
                "description text",
                "hobby text",
                "dob text",
                "allow_public text",
                "join_date text"
                ])
            
            // select
            let statement = mydb.fetch("user", cond: "User_ID != ''  ", order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let User_id = String(cString: sqlite3_column_text(statement, 0))
                let S_Name = String(cString: sqlite3_column_text(statement, 1))
                let G_Name = String(cString: sqlite3_column_text(statement, 2))
                let M_Name = String(cString: sqlite3_column_text(statement, 3))
                let phone = String(cString: sqlite3_column_text(statement, 4))
                let area_code = String(cString: sqlite3_column_text(statement, 5))
                let gender = String(cString: sqlite3_column_text(statement, 6))
                let desc = String(cString: sqlite3_column_text(statement, 7))
                let hobby = String(cString: sqlite3_column_text(statement, 8))
                let dob = String(cString: sqlite3_column_text(statement, 9))
                let allow_public = String(cString: sqlite3_column_text(statement, 10))
                let join_date = String(cString: sqlite3_column_text(statement, 11))
                
                loginModel.User_ID = User_id
                loginModel.S_Name = S_Name
                loginModel.G_Name = G_Name
                loginModel.M_Name = M_Name
                loginModel.phone = phone
                loginModel.Area_Code = area_code
                loginModel.gender = gender
                loginModel.Description = desc
                loginModel.Hobby = hobby
                loginModel.dob = dob
                loginModel.Allow_Public = allow_public
                loginModel.join_date = join_date
                
                loginModel.setStatus(status: true)
                
                loginArray.add(User_id)
                loginArray.add(S_Name)
                loginArray.add(G_Name)
                loginArray.add(M_Name)
                loginArray.add(phone)
                loginArray.add(area_code)
                loginArray.add(gender)
                loginArray.add(desc)
                loginArray.add(hobby)
                loginArray.add(dob)
                loginArray.add(allow_public)
                loginArray.add(join_date)
                
                print("\(User_id). \(S_Name). \(G_Name)")
            }
            sqlite3_finalize(statement)
            
            
            
        }
        
        self.listTableView.refreshControl = self.refreshControl
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.urlPath = "https://triplan.scarletsc.net/iOS/main.php"
        homeModel.downloadItems()
        
        if currentReachabilityStatus == .notReachable {
            let alert = UIAlertController(title: "Network Error", message: "Network Unavailable. \nFailed to download data.", preferredStyle: UIAlertControllerStyle.alert)
            
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
        
        if !loginModel.isLoggedIn(){
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as? UINavigationController
            {
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.urlPath = "https://triplan.scarletsc.net/iOS/main.php"
        self.downloadItems()
        self.listTableView.reloadData()
        self.tabBarController?.tabBar.barStyle = .default
        self.tabBarController?.tabBar.alpha = 1
        
    }
    
    @IBAction func menuBarBtn(_ sender: UIBarButtonItem) {
        
        if loginModel.isLoggedIn(){
            
            Menu(self).show()
            
        }else{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNav") as? UINavigationController
            {
                
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "detailSegue"){
            
            // Get reference to the destination view controller
            
            if let sender = sender as? UICollectionViewCell{
                let indexPath = self.listTableView.indexPath(for: sender)
                
                selectedArticle = feedItems[(indexPath?.row)!] as! ArticleModel
                
            }
            
            let detailVC  = segue.destination as! DetailViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            self.segueDest = ""
            detailVC.selectedArticle = selectedArticle
            detailVC.loginModel = loginModel
            
        }
        
        if(segue.identifier == "postingSegue"){
            
            // Get reference to the destination view controller
            let detailVC  = segue.destination as! PostingViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            self.segueDest = ""
            detailVC.loginModel = loginModel
            detailVC.source = self
        }
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
