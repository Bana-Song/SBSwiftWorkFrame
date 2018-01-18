//
//  CustomTextView.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/21.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    private var placeHolder:String?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func setPlaceHolder(placeHolder:String) {
        self.placeHolder = placeHolder
        self.textColor = UIColor.gray
        self.text = placeHolder;
    }
    
    
    func textViewDidBeginEditing () {
        if (self.text as String) == placeHolder {
            self.text = "";
        }
        self.textColor = UIColor.black;
    }
    
    func textViewDidEndEditing () {
        if self.text.characters.count == 0 {
            self.textColor = UIColor.gray;
            self.text = self.placeHolder;
        }
    }
    
    func  shouldChangeTextInRange(text:String?) -> Bool{
        if text == "\n" {
            self.resignFirstResponder();
            return false
        }
        return true
    }
    
    func LimitLength(maxLength:Int) {
        if self.text.characters.count > maxLength {
            let index = self.text.index(self.text.startIndex, offsetBy: maxLength)
            self.text = self.text.substring(to: index);
//            self.text = 
        }
    }
}
