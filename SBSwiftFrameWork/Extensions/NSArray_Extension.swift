//
//  NSArray_Extension.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/16.
//  Copyright © 2016年 Bana. All rights reserved.
//

import Foundation

extension Array {
    //去重
    func clearRepeat() -> [AnyObject] {
        var dict = Dictionary<String,AnyObject>();
        for number in self {
            dict[number as! String] = number as AnyObject?;
        }
        var resultAry = [AnyObject]();
        
        for value in dict.values {
            resultAry.append(value);
        }
        return resultAry;
    }
    
    //逆序
    func descAry() -> [AnyObject] {
        var resultAry = [AnyObject]();
        for value in self.reversed() {
            resultAry.append(value as AnyObject);
        }
        return resultAry;
    }
    
}
