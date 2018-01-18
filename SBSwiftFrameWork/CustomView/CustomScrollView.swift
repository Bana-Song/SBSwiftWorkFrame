//
//  CustomScrollView.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/21.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self);
            return fabs(translation.x) > fabs(translation.y)
        }
        
        return true;
    }

}
