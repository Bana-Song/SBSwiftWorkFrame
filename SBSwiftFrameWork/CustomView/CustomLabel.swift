//
//  CustomLabel.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/12.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

enum SBCustomLabelLineType{
    case typeDefault  //没有线条
    case typeTop       //上划线
    case typeMiddle    //中划线
    case typeBottom     //下划线
}//自定义线条类型


class CustomLabel: UILabel {

    var lineType:SBCustomLabelLineType = .typeDefault
    var lineColor:UIColor = UIColor.lightGray
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        //判断需要划线的类型
        switch lineType {
        case .typeDefault:
            break;
        case .typeTop:
           drawLine(2);
            break;
        case .typeMiddle:
            drawLine(self.frame.size.height * 0.5)
            break;
        case .typeBottom:
            drawLine(self.frame.size.height - 2);
            break;
        default:
            break;
        }

    }
    
    func drawLine(_ height:CGFloat) {
        let x:CGFloat = 0;
        let y:CGFloat = height;
        let w:CGFloat = self.frame.size.width;
        let h:CGFloat = 1;
        
        var R,G,B,A :CGFloat;
        
        let color = lineColor.cgColor;
        let numComponents = color.numberOfComponents;
        let context = UIGraphicsGetCurrentContext();
        
        if( numComponents == 4)
        {
            let components = color.components;
            R = (components?[0])!;
            G = (components?[1])!;
            B = (components?[2])!;
            A = (components?[3])!;
            //填充色
            context?.setFillColor(red: R, green: G, blue: B, alpha: A);
        }
        //填充文字
        context?.fill(CGRect(x: x, y: y, width: w, height: h));
    }

    
    //设置自定大小，字体默认设置
    func fontWidthSize(_ size:CGFloat) {
        let font = UIFont.init(name: "Arial", size: size);
        self.font = font;
    }
    
    //自适应
    func setFitToWidth(fontSize:CGFloat,maxWidth:CGFloat) {
        let font = UIFont.systemFont(ofSize: fontSize);
        let rect = (self.text! as NSString).boundingRect(with: CGSize.init(width: maxWidth, height: ScreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil);
        self.changeFrame(x: nil, y: nil, w: NSNumber(value: Float(rect.width)),h: nil);
    }
    
    func setFitToHeight(fontSize:CGFloat,maxHeight:CGFloat) {
        let font = UIFont.systemFont(ofSize: fontSize);
        let rect = (self.text! as NSString).boundingRect(with: CGSize.init(width: ScreenWidth, height: maxHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil);
        self.changeFrame(x: nil, y: nil, w: nil ,h: NSNumber(value: Float(rect.height)));

    }
    
    
    private func changeFrame(x:NSNumber?,y:NSNumber?,w:NSNumber?,h:NSNumber?) {
        var orginX = self.frame.origin.x;
        var orginY = self.frame.origin.y;
        var orginW = self.frame.size.width;
        var orginH = self.frame.size.height;
        if x != nil {
            orginX = CGFloat((x?.floatValue)!);
        }
        if y != nil {
            orginY = CGFloat((y?.floatValue)!);
        }
        if w != nil {
            orginW = CGFloat((w?.floatValue)!);
        }
        if h != nil {
            orginH = CGFloat((h?.floatValue)!);
        }
        self.frame = CGRect.init(x: orginX, y: orginY, width: orginW, height: orginH);
    }
    
    func setLine(lineColor:UIColor?,lineType:SBCustomLabelLineType) {
        if (lineColor == nil) {
            self.lineColor = self.textColor;
        }else{
            self.lineColor = lineColor!;
        }
        self.lineType = lineType;
    }

    
    func setCustomStyleWithModelAry(modelAry:Array<SBLabelMember>) {
        var readStr = "";
        var showStr = "";
        for  member in modelAry
        {
            showStr += member.text!;
        }
        
        var str = NSMutableAttributedString.init(string: showStr);
        for i in 0..<modelAry.count {
            let member = modelAry[i];
            str.addAttributes([NSAttributedStringKey.foregroundColor:member.textColor,NSAttributedStringKey.font:member.font], range: NSMakeRange(readStr.characters.count, (member.text?.characters.count)!))
            readStr += member.text!;
        }
        self.attributedText = str;

    }
}
