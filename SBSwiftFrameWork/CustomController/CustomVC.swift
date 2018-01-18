//
//  CustomVC.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/11.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

class CustomVC: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
