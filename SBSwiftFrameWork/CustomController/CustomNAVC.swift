//
//  CustomNAVC.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/11.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class CustomNAVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage.init(named: "SBNa"), for: .default);
        let navigationTitleAttribute = NSDictionary.init(dictionary: [NSAttributedStringKey.foregroundColor:UIColor.white]);
        self.navigationBar.titleTextAttributes = navigationTitleAttribute as! [NSAttributedStringKey : Any];
        let navigationImageView = self.hairlineImageViewInNavigationBar((self.navigationController?.navigationBar)!)
        navigationImageView!.isHidden = true;//隐藏黑线，如需开启，请改为false
        
    }
    
    func hairlineImageViewInNavigationBar (_ view:UIView)->UIImageView? {
        if view.isKind(of: UIImageView.classForCoder()) && view.bounds.size.height <= 1 {
            return view as! UIImageView;
        }
        let subViews = view.subviews
        for subV in subViews {
            let imgView = self.hairlineImageViewInNavigationBar(subV);
            if imgView == nil {
                return imgView;
            }
        }
        return nil;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
