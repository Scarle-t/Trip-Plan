//
//  PostingViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 23/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit
import Foundation

class PostingViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,URLSessionDataDelegate, CategoryDownloadProtocol, PostingProtocol {
    
    func posted(status: Bool) {
        if status {
            let alert = UIAlertController(title: "Posted", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.dismiss(animated: true, completion: {()->Void in
                        
                    });
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    var category : NSMutableArray = ["Select Category ..."]
    
    var catArray :NSArray = NSArray()
    
    func itemsDownloaded(items: NSArray) {
        catArray = Session.sharedInstance.loadCat()
        category.addObjects(from: catArray as! [String])
    }
    
    func postDownloaded(items: NSArray) {
        
    }
    
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return category[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        txtCategory.text = category[row] as? String
    }
    
    @IBAction func btnPhotoUpload(_ sender: UIButton) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var imgPreview: UIImageView!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        //let imageData:Data = UIImagePNGRepresentation(image_data!)!
        
        imgPreview.image = image_data
        
        //let imageStr = imageData.base64EncodedString()
        //print(imageStr)
  
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func imageUploadRequest(imageView: UIImageView, uploadUrl: NSURL, param: [String:String]?) {
        
        //let myUrl = NSURL(string: "http://192.168.1.103/upload.photo/index.php");
        
        let request = NSMutableURLRequest(url:uploadUrl as URL);
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        //myActivityIndicator.startAnimating();
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            if let data = data {
// You can print out response object                                                         print("******* response = \(response)")
                print(data.count)
                // you can use data here
                // Print out reponse body
                let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print("****** response data = \(responseString!)")
                do{
                let json =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    
                    print("json value \(json)")
                    
                }catch (_){
                    
                }
                
                //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                DispatchQueue.main.async(execute: { () -> Void in
                    //self.myActivityIndicator.stopAnimating()
                    //self.imageView.image = nil;
                    
                });
                
            }
        })
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if let uid = parameters!["postid"] {
        
            let filename = "\(uid).jpg"
            let mimetype = "image/jpg"
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            
            body.appendString(string: "--\(boundary)--\r\n")
        }
        
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
    
    
    var loginModel : LoginModel?

    @IBOutlet weak var navShare: UIBarButtonItem!
    
    @IBOutlet weak var textFieldTitle: UITextField!
    
    @IBOutlet weak var textViewContent: UITextView!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBAction func postingTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var txtCategory: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let categoryModel = CategoryDownload()
        categoryModel.delegate = self
        categoryModel.urlPath = "https://triplan.scarletsc.net/iOS/category.php"
        categoryModel.downloadItems()
        
        let myPickerView = UIPickerView()
        
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        txtCategory.inputView = myPickerView
        
        txtCategory.text = category[0] as? String
        
        txtCategory.tag = 100
        
        navShare.isEnabled = false
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textViewContent.layer.borderWidth = 0.5
        textViewContent.layer.borderColor = borderColor.cgColor
        textViewContent.layer.cornerRadius = 5.0
        
        textViewContent.text = "Content"
        textViewContent.textColor = UIColor.lightGray
        
        loginModel = Session.sharedInstance.loadDatas()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !(loginModel?.isLoggedIn())! {
            let alert = UIAlertController(title: "You are not logged in", message: "Please login first", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
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
            
        }else{
            var usrname :String
            
            if loginModel?.M_Name != nil {
                usrname = (loginModel?.S_Name)! + " " +  (loginModel?.M_Name)! + " " +  (loginModel?.G_Name)!
            }else{
                usrname = (loginModel?.S_Name)! + " " + (loginModel?.G_Name)!
            }
            
            username.text = usrname
        }
        
       
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
            navShare.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Content"
            textView.textColor = UIColor.lightGray
            navShare.isEnabled = false
        }
    }
    
    @IBAction func postingCancel(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Cancel Post", message: "Are you sure you want to cancel?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                self.dismiss(animated: true, completion: {()->Void in
                    
                });
                
            }}))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func postingDone(_ sender: UIBarButtonItem) {
        
        let postID = "\(Calendar.current.component(.month, from: Date()))\(Calendar.current.component(.day, from: Date()))\(Calendar.current.component(.hour, from: Date()))\(Calendar.current.component(.second, from: Date()))\(arc4random_uniform(9))"
        let catID = category.index(of: txtCategory.text)
        if let userid = loginModel?.User_ID
            , let location = txtAddress.text?.replacingOccurrences(of: " ", with: "")
        , let title = textFieldTitle.text?.replacingOccurrences(of: " ", with: "%20")
        , let content = textViewContent.text?.replacingOccurrences(of: " ", with: "%20"){
            print("https://triplan.scarletsc.net/iOS/posting.php?User_ID=\(userid)&postID=\(postID)&title=\(title)&content=\(content)&location=\(location)&catid=\(catID)")
            imageUploadRequest(imageView: imgPreview, uploadUrl: NSURL(string: "https://triplan.scarletsc.net/iOS/imgUpload.php")!, param: ["postid" : postID])
            let posting = PostingModel()
            posting.delegate = self
            posting.urlPath = "https://triplan.scarletsc.net/iOS/posting.php?UserID=\(userid)&postID=\(postID)&title=\(title)&content=\(content)&location=\(location)&catid=\(catID)"
            posting.downloadItems()
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

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
