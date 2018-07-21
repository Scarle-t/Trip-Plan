//
//  imgViewController.swift
//  Trip Plan
//
//  Created by Scarlet on 22/4/2018.
//  Copyright © 2018 Chi Hin Ng. All rights reserved.
//

import UIKit

class imgViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var imgScroll: UIScrollView!
    
    
    var selectedImg : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
        // Do any additional setup after loading the view.
        imgScroll.minimumZoomScale = 1.0
        imgScroll.maximumZoomScale = 6.0
        imgDetail.contentMode = .scaleAspectFit
        imgDetail.image = selectedImg
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var btnView: UIView!
    
    @IBAction func imgTap(_ sender: UITapGestureRecognizer) {
        
        if btnView.alpha == 0{
            UIView.animate(withDuration: 0.2) {
                self.btnView.alpha = 1
            }
            
        }else{
            UIView.animate(withDuration: 0.2) {
                self.btnView.alpha = 0
            }
        }
        
    }
    
    var initialTouchPoint = CGPoint.zero
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }
    
    @IBAction func navShare(_ sender: Any) {
        
        // text to share
        let image = selectedImg
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgDetail
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
