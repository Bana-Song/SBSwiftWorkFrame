
//
//  NSString_Extension.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/16.
//  Copyright © 2016年 Bana. All rights reserved.
//

import Foundation

enum SBFormatType {
    case SBFormatTypeEmail, //邮箱
    SBFormatTypeURL, //网址
    SBFormatTypeIDCard, //身份证号
    SBFormatTypeUserName, //字母和数字 6-20位
    SBFormatTypeIP, //IP地址
    SBFormatTypePassword, //汉字、数字、字母、下划线，下划线位置不限
    SBFormatTypePhone //电话
}


extension String {
    
    /** 判断字符是否为空 */
    static func isBlankString(string:String) -> Bool{
        if (string.isEmpty) {
            return true;
        }
        if string.trimmingCharacters(in: CharacterSet.whitespaces).characters.count == 0 {
            return true;
        }
        return false;

    }
    
    /** md5 32位加密 （小写） */
    static func md5StrFor32(string:String) -> String {
        let cStr = string.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 32)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 32{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    /** md5 16位加密 （大写） */
    static func md5StrFor16(string:String) -> String {
        let cStr = string.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    
    /** 验证格式是否正确，不带提示框 */
    static func isCorrectFormat(string:String,type:SBFormatType) -> Bool {
        var regex = "";
        if String.isBlankString(string: string) {
            return false;
        }
        switch type {
        case .SBFormatTypeEmail:
            regex = mailRegex;
            break;
        case .SBFormatTypeIP:
            regex = ipRegex;
            break;
        case .SBFormatTypeURL:
            regex = httpUrlRegex;
            break;
        case .SBFormatTypeIDCard:
            regex = IDCardRegex;
            break;
        case .SBFormatTypePassword:
            regex = passWordRegex;
            break;
        case .SBFormatTypeUserName:
            regex = userNameRegex;
            break;
        case .SBFormatTypePhone:
            regex = phonenumRegex;
            break;
        default:
            break;
        }
        let exp = try? NSRegularExpression.init(pattern: regex, options: .caseInsensitive);
        let expResult = exp?.firstMatch(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: string.characters.count));
        if (expResult != nil) {
            return true;
        }
        return false;
    }
    
    /** 验证格式是否正确，带提示框 */
    static func isCorrectFormat(string:String,type:SBFormatType,alertMsg:String) -> Bool {
        if String.isCorrectFormat(string: string, type: type) {
            return true;
        }
        SBProgressHUDView.sharedInstance.showErrorWithStatus(alertMsg);
        return false;
    }
}
