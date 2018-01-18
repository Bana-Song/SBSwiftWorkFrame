//
//  CustomView.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/12.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    func SBRequestWithParams(params:NSDictionary?
        ,apiName:String
        ,serverURL:String?
        ,isGet:Bool
        ,isNeedHUD:Bool
        ,loadTitle:String?
        ,sucessTitle:String?
        ,failTitle:String?
        ,flag:String?){
        let sbNet = SBNet().SBRequest(paramDic:params, apiName: apiName, baseUrl: serverURL, isGet: isGet, isNeedHUD: isNeedHUD, waitingStatus: loadTitle, sucessStatus: sucessTitle, failureStatus: failTitle, sucessBlockWay: { (result:AnyObject, apiName:String) in
            self.SBRequestSucess(result, ApiName: apiName)
        }, netFailureBlockWay: { (error:NSError) in
            self.SBRequestFail(error,apiName: apiName)
        }) { (result:[NSObject : AnyObject]) in
            
        }
    }
    
    func SBRequestSucess(_ _responseObject:AnyObject,ApiName:String) {
        
    }
    
    func SBRequestFail(_ _error:NSError,apiName:String) {
        
    }
    


}
