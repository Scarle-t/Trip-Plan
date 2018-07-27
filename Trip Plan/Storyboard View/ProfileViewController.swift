//
//  ProfileViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 26/7/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var userIcon: UIImage?
    var userName: String?
    let layout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var list: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TrendingCell
        
        myCell.title.text = "test"
        
        myCell.cover.image = UIImage(imageLiteralResourceName: "Icon")
        myCell.cover.contentMode = .scaleAspectFit
        
        myCell.layer.borderWidth = 1
        myCell.layer.borderColor = UIColor.lightGray.cgColor
        
        return myCell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        
        let image = UIImageView()
        let username = UILabel()
        
        if kind == UICollectionElementKindSectionHeader {
            
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            
            reusableView.backgroundColor = UIColor.white
            image.image = userIcon
            username.text = userName!
            username.textAlignment = .center
            
            if let window = UIApplication.shared.keyWindow{
                image.frame = CGRect(x: (window.frame.width / 2) - 60, y: 5, width: 120, height: 120)
                
                username.frame = CGRect(x: image.frame.minX, y: image.frame.maxY + 10, width: image.frame.width, height: 30)
            }
            
        }
        
        reusableView.addSubview(image)
        reusableView.addSubview(username)
        
        return reusableView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        list.delegate = self
        list.dataSource = self
        
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 170)
        
//        list.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
//        list = UICollectionView(frame: list.frame, collectionViewLayout: layout)
        
    }
    
    @IBAction func dismis(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
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
