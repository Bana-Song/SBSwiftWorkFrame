//
//  CustomButton.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/12.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setShadow(offset:CGSize,alpha:CGFloat, color:UIColor?,radius:CGFloat) {
        var color = color
        if color == nil {
            color = UIColor.black;
        }
        self.layer.shadowColor = color?.cgColor;
        self.layer.shadowOffset = offset;
        self.layer.shadowOpacity = Float(alpha);
        //self.layer.masksToBounds = NO;
        self.layer.shadowRadius = radius;//阴影半径，默认3
    }
    
    func titleFontWithSize(size:CGFloat) {
        let font = UIFont(name: "Arial", size: size);
        self.titleLabel?.font = font;
    }

}
