//
//  UIImage_Extension.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/16.
//  Copyright © 2016年 Bana. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /** 等比例缩放图片 */
    func resizeImageWithSize(size:CGSize) -> UIImage{
        //获取原图的属性
        let imageSize = self.size;
        let width = imageSize.width;
        let height = imageSize.height;
        
        //新图形的属性
        var newImage:UIImage?;
        let targetWidth = size.width;
        let targetHeight = size.height;
        
        //缩放比例,按宽的来
        var scaleFactor = 0.0;
        var scaleWidth = targetWidth;
        var scaleHeight = targetHeight;
        
        //裁剪的起始点
        var thumbnailPoint = CGPoint.init(x: 0, y: 0);
        
        if __CGSizeEqualToSize(imageSize, size) == false {
            let widthFactor = targetWidth / width;
            let heightFactor = targetHeight / width;
            //获取等比例
            if widthFactor > heightFactor {
                scaleFactor = Double(widthFactor);
            }else{
                scaleFactor = Double(heightFactor);
            }
            scaleWidth = width * CGFloat(scaleFactor);
            scaleHeight = height * CGFloat(scaleFactor);
            
            //获取裁剪原始点
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5;
            }else{
                thumbnailPoint.x = (targetWidth - scaleWidth) * 0.5;
            }
        }
        
        //开始裁剪
        UIGraphicsBeginImageContext(size);
        var thumbnailRect = CGRect.init();
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaleWidth;
        thumbnailRect.size.height =  scaleHeight;
        self.draw(in: thumbnailRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()!;
        if newImage == nil {
            SBLog("scale image fail");
        }
        UIGraphicsEndImageContext();
        //结束裁剪
        return newImage!;
    }
    
    /** 等比例缩放图片，宽度不能超出maxWidth */
    func resizeImageWithMaxWidth(maxWidth:CGFloat) -> UIImage{
        let imageSize = self.size;
        let width = imageSize.width;
        let height = imageSize.height;
        let targetWidth = maxWidth;
        let targetHeight = height / (width / maxWidth);
        let size = CGSize.init(width: targetWidth, height: targetHeight);
        return self.resizeImageWithSize(size: size);
    }
    
    /** 根据Color和Size生成Image */
    static func imageWithColor(color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height);
        //使用位图的方式，类似于截图
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img!;
    }
    
    /** UIView转换为Image */
    static func imageWithView(view:UIView) -> UIImage {
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(view.bounds.size);
        let currnetContext = UIGraphicsGetCurrentContext();
        view.layer.render(in: currnetContext!);
        // 从当前context中创建一个改变大小后的图片
        let image = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        return image!;
    }
    
    /** 图片转base64 */
    func base64String()-> String {
        let data = UIImagePNGRepresentation(self)?.base64EncodedData(options: Data.Base64EncodingOptions.lineLength64Characters);
        let base64Str = data?.base64EncodedString();
        return base64Str!;
    }
    
    /** 修改图片透明度 */
    func imageByApplyingAlpha(alpha:CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height);
        ctx!.scaleBy(x: 1, y: -1);
        ctx!.translateBy(x: 0, y: -area.size.height);
        ctx?.setBlendMode(CGBlendMode.multiply);
        ctx?.setAlpha(alpha);
        ctx?.draw(self.cgImage!, in: area);

        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
}
