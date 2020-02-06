//
//  DetailViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 18/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, CommentDownloadProtocol, CommentPostingProtocol {
    
    func posted(status: Bool) {
        if status{
            cmt.delegate = self
            if let id = selectedArticle?.Article_ID {
                cmt.urlPath = "https://triplan.scarletsc.net/iOS/comments.php?id=\(id)"
            }
            cmt.downloadItems()
            
            commentList.reloadData()
            
        }
    }
    
    func itemsDownloaded(items: NSArray) {
        feedComments = items
        controls.setTitle("\(feedComments.count) Comments", forSegmentAt: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedComments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CommentCollectionViewCell
        
        let comment = feedComments[indexPath.row] as! CommentModel
        
        if comment.M_Name == ""{
            myCell.cmt_name.text = comment.S_Name! + " " + comment.G_Name!
        }else{
            myCell.cmt_name.text = comment.S_Name! + " " + comment.M_Name! + " " + comment.G_Name!
        }
        
        myCell.cmt_content.text = comment.comment!
        
        myCell.cmt_date.text = comment.cmt_Date!
        
        return myCell
        
    }
    
    let postCmt = CommentPosting()
    
    let cmt = CommentDownload()
    
    var feedComments: NSArray = NSArray()
    
    var feedItems: NSArray = NSArray()
    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var commentList: UICollectionView!
    
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearch.Request!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearch.Response!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var selectedArticle : ArticleModel?
    var loginModel : LoginModel?
    
    var selectedImg : UIImage?
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgDetail.image = UIImage(data: data)
                self.selectedImg = UIImage(data: data)
            }
        }
    }
    
    @IBOutlet weak var mapsView: UIView!
    
    @IBOutlet weak var articleView: UIView!
    
    @IBOutlet weak var commentView: UIView!
    
    @IBAction func sepView(_ sender: UISegmentedControl) {
    
        switch sender.selectedSegmentIndex {
        case 0:
            mapsView.isHidden = true
            articleView.isHidden = false
            commentView.isHidden = true
            controlSep.effect = UIBlurEffect(style: .light)
            controls.tintColor = self.view.tintColor
            self.tabBarController?.tabBar.barStyle = .default
            
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.alpha = 1
            }
            
        case 1:
            mapsView.isHidden = false
            articleView.isHidden = true
            commentView.isHidden = true
            controlSep.effect = segBlurView.effect
            controls.tintColor = mapSeg.tintColor
            if mapView.mapType == .hybrid{
                self.tabBarController?.tabBar.barStyle = .black
            }else{
                self.tabBarController?.tabBar.barStyle = .default
            }
            
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.alpha = 0
            }
            
        case 2:
            mapsView.isHidden = true
            articleView.isHidden = true
            commentView.isHidden = false
            controlSep.effect = UIBlurEffect(style: .light)
            controls.tintColor = self.view.tintColor
            self.tabBarController?.tabBar.barStyle = .default
            
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.alpha = 1
            }
            cmt.delegate = self
            if let id = selectedArticle?.Article_ID {
                cmt.urlPath = "https://triplan.scarletsc.net/iOS/comments.php?id=\(id)"
            }
            cmt.downloadItems()
            commentList.reloadData()
            
        default:
            break
        }
    
    }
    
    @IBOutlet weak var txtCmt: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let postID = selectedArticle?.Article_ID else {return false}
        guard let userID = loginModel?.User_ID else {return false}
        guard var cmtTxt = txtCmt.text else {return false}
        
        cmtTxt = cmtTxt.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        postCmt.urlPath = "https://triplan.scarletsc.net/iOS/postCmt.php?postID=\(postID)&id=\(userID)&cmt=\(cmtTxt)"
        postCmt.downloadItems()
        
        if let id = selectedArticle?.Article_ID {
            self.cmt.urlPath = "https://triplan.scarletsc.net/iOS/comments.php?id=\(id)"
        }
        cmt.downloadItems()
        commentList.reloadData()
        textField.text = nil
        textField.resignFirstResponder()
        
        return false
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let id = selectedArticle?.Article_ID {
            cmt.urlPath = "https://triplan.scarletsc.net/iOS/comments.php?id=\(id)"
        }
        cmt.downloadItems()
        
        commentList.reloadData()
        
        return true
    }
    
    @objc func dismissCmt(){
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentList.delegate = self
        commentList.dataSource = self
        
        txtCmt.delegate = self
        
        let toolBar = UIToolbar()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissCmt))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtCmt.inputAccessoryView = toolBar
        
        cmt.delegate = self
        if let id = selectedArticle?.Article_ID {
            cmt.urlPath = "https://triplan.scarletsc.net/iOS/comments.php?id=\(id)"
        }
        cmt.downloadItems()
        
        postCmt.delegate = self
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 22.17, longitude: 114.09)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = selectedArticle?.address
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.selectedArticle?.address
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.title = self.selectedArticle!.Title 
        self.navBar.title = self.selectedArticle!.Title
        self.txtDetail.text = self.selectedArticle!.Content
        if self.selectedArticle?.M_Name == nil{
            self.lblDetail.text = self.selectedArticle!.S_Name! + " " + self.selectedArticle!.G_Name!
        }else{
            self.lblDetail.text = self.selectedArticle!.S_Name! + " " + self.selectedArticle!.M_Name! + " " + self.selectedArticle!.G_Name!
        }
        if let url = URL(string: self.selectedArticle!.media_path!) {
            downloadImage(url: url)
        }
        
        loginModel = Session.sharedInstance.loadDatas()
        
        if !(loginModel?.isLoggedIn())!{
            
            txtCmt.isEnabled = false
            
        }
        
        commentList.reloadData()
        
    }
    
    @IBAction func navShare(_ sender: UIBarButtonItem) {
        // text to share
        let text = "Share via Trip Plan iOS \nhttps://triplan.scarletsc.net/post.php?article=" + self.selectedArticle!.Article_ID!
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "imgSegue"{
            // Get reference to the destination view controller
            let detailVC  = segue.destination as! imgViewController
            // Set the property to the selected location so when the view for
            // detail view controller loads, it can access that property to get the feeditem obj
            
            detailVC.selectedImg = selectedImg
        }

    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func mapTypeSwitch(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
            segBlurView.effect = UIBlurEffect(style: .light)
            controlSep.effect = UIBlurEffect(style: .light)
            mapSeg.tintColor = self.view.tintColor
            controls.tintColor = mapSeg.tintColor
            openMapsBtn.setImage(UIImage(imageLiteralResourceName: "Share"), for: .normal)
            self.tabBarController?.tabBar.barStyle = .default
        case 1:
            mapView.mapType = .hybrid
            segBlurView.effect = UIBlurEffect(style: .dark)
            controlSep.effect = UIBlurEffect(style: .dark)
            mapSeg.tintColor = UIColor.white
            controls.tintColor = mapSeg.tintColor
            openMapsBtn.setImage(UIImage(imageLiteralResourceName: "Share_white"), for: .normal)
            self.tabBarController?.tabBar.barStyle = .black
        default:
            break
        }
        
    }
    
    @IBOutlet weak var openMapsBtn: UIButton!
    @IBOutlet weak var segBlurView: UIVisualEffectView!
    @IBOutlet weak var mapSeg: UISegmentedControl!
    @IBOutlet weak var controlSep: UIVisualEffectView!
    @IBOutlet weak var controls: UISegmentedControl!
    
    @IBAction func openMaps(_ sender: UIButton) {
        
        let mapString =
        "maps://?ll=\(pointAnnotation.coordinate.latitude),\(pointAnnotation.coordinate.longitude)"
        
        UIApplication.shared.open(URL(string: mapString)!, completionHandler: nil)
        
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
