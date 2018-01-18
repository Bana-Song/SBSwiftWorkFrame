//
//  NSDate_Extension.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/16.
//  Copyright © 2016年 Bana. All rights reserved.
//

import Foundation
extension Date {
    //时间格式的转换  PS：yyyy-MM-dd hh(HH):mm:ss HH为24小时制，hh为12小时制
   
    
    /** 将时间字符串从一个格式转换成另外一个格式 */
    static func transitionTimeString(timeStr:String,fromFormat:String,toFormat:String) -> String {
        let format = DateFormatter.init();
        format.dateFormat = fromFormat;
        let date = format.date(from: timeStr);
        format.dateFormat = toFormat;
        return format.string(from: date!);
    }
    
    /** 将NSDate转换成字符串形式 */
    static func stringFromDate(date:Date,fromFormat:String) -> String {
        let format = DateFormatter.init();
        format.dateFormat = fromFormat;
        return format.string(from: date);
    }
    
    /** 将时间从字符串形式转换成NSDate */
    static func dateFromString(timeStr:String,fromFormat:String) -> Date {
        let format = DateFormatter.init();
        format.dateFormat = fromFormat;
        return format.date(from: timeStr)!;
    }
    
    /** 获取距离当前时间 n 天的时间（String格式）;
     PS:   ( NSTimeInterval secondsPerDay =) 24*60*60 (一天24小时，一小时60分，一分60秒);
     正负代表前后
     */
    static func stringFromTimeInterval(interval:TimeInterval,fromFormat:String) -> String {
        let date = Date.init(timeIntervalSinceReferenceDate: interval);
        return Date.stringFromDate(date: date, fromFormat: fromFormat);
    }
    
    /** 根据字符时间获取距离当前时间的判断.
     PS:只判断了在当前时间之前
     */
    static func judgeFromStringDate(timeStr:String,fromFormat:String) -> String {
        let currentDate = Date.dateFromString(timeStr: timeStr, fromFormat: fromFormat);
        var timeInterval = currentDate.timeIntervalSinceNow;
        timeInterval = -timeInterval;
        
        var temp = 0;
        var result = "";
        if (timeInterval < 60) {
            result = "刚刚";
            return result;
        }
        
        temp = Int(timeInterval / 60);
        if  temp < 60
        {
            result = String(temp) + "分钟前";
            return result;
        }
        
        temp = Int(temp / 60);
        if temp  < 24
        {
            result = String(temp) + "小时前";
            return result;
        }
        
        
        temp = Int(temp / 24);
        if temp < 30
        {
            result = String(temp) + "天前";
            return result;
        }
        
         temp = Int(temp / 30);
        if  temp < 12
        {
            result = String(temp) + "月前";
        }
        else
        {
            temp = temp/12;
            result = String(temp) + "年前";
        }
        return result;
    }
    
    
    /** 根据字符时间计算实岁年龄 
     */
    static func judgeFromStringDateToAge(timeStr:String,fromFormat:String) -> Int {
        let birthDate = Date.dateFromString(timeStr: timeStr, fromFormat: fromFormat);
        
        //获取生日年月日
        let components1 = Calendar.current.dateComponents([.day,.month,.year], from: birthDate);
        let birthYear = components1.year;
        let birthMonth = components1.month;
        let birthDay = components1.day;
        
        //获取系统 年月日
        let components2 = Calendar.current.dateComponents([.day,.month,.year], from: Date.init());
        let currentYear = components2.year;
        let currentMonth = components2.month;
        let currentDay = components2.day;
        
        
        //计算年龄
        var iAge = currentYear! - birthYear! - 1;
        if currentMonth! > birthMonth! || currentDay! >= birthDay! {
            iAge += 1;
        }
        return iAge;
    }
}
