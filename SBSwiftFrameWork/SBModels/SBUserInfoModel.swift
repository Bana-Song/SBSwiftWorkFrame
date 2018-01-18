//
//  SBUserInfoModel.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/10.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class SBUserInfoModel: NSObject,NSCoding{
    var userName:String = ""
    var passWord:String = ""
    var userID:Int = -1; //-1 表示没有用户id
    var isLogin:Int = 0; //0:未登录 1:登录
    var token:String = "" //网络请求中的头文件中的token
    
    var age:Int = -1; //-1表示未填写，年龄
    var nickName:String = "昵称" //昵称
    var signName:String = "" //个性签名
    var headerPic:String = "" //头像
    
    override init() {
        super.init();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init();
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String;
        self.passWord = aDecoder.decodeObject(forKey: "passWord") as! String;
        self.userID = aDecoder.decodeInteger(forKey: "userID");
        self.isLogin = aDecoder.decodeInteger(forKey: "isLogin");
        self.token = aDecoder.decodeObject(forKey: "token") as! String;
        self.age = aDecoder.decodeInteger(forKey: "age");
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as! String;
        self.signName = aDecoder.decodeObject(forKey: "signName") as! String;
        self.headerPic = aDecoder.decodeObject(forKey: "headerPic") as! String;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.passWord, forKey: "passWord")
        aCoder.encode(self.isLogin, forKey: "isLogin")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.nickName, forKey: "nickName")
        aCoder.encode(self.signName, forKey: "signName")
        aCoder.encode(self.headerPic, forKey: "headerPic")
    }
    
}
