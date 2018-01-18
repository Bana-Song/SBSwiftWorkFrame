//
//  SBNet.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/10.
//  Copyright © 2016年 Bana. All rights reserved.
//

import Alamofire
import UIKit


let APIServerAddress  =  "192.168.4.90:9001/api";

typealias sbNetSucessBlock =  (_ result:AnyObject,_ flag:String) -> Void  //block 定义 ,返回值是个对象 请求成功后走的方法

typealias sbNetNetfailureBlock = (_ error:NSError) -> Void  // block 返回错误信息 ，这个是请求错误

typealias sbNetFaillureBlock = (_ error:[NSObject : AnyObject]) -> Void //block 返回参数状态不对（如：登录实效）



class SBNet: NSObject {
    
    /** 单例模式 */
    private static let sharedInstance = SBNet()
    class var sharedSBNet: SBNet {
        return sharedInstance;
    }
    
    let progressView = SBProgressHUDView.sharedInstance
    
  
   internal func SBRequest (paramDic:NSDictionary?, //传的参数
        apiName:String,   //api 的名字
        baseUrl:String?,  //默认是全局的，但特殊的可以写
        isGet:Bool   //方法确认
        ,isNeedHUD:Bool //是否需要转圈提示框
        ,waitingStatus:String?  //等待提示语
        ,sucessStatus:String?  //成功提示语
        ,failureStatus:String?  //失败提示语
        ,sucessBlockWay : @escaping sbNetSucessBlock
        ,netFailureBlockWay : @escaping sbNetNetfailureBlock
        , failureBlockWay:@escaping  sbNetFaillureBlock
        ){
        let userModel = SBGetLocalModel()
        let getToke = userModel.token;
        
        var sbBaseURL = "";
        if(baseUrl == nil){
            
            sbBaseURL = APIServerAddress + "/api";
        }else{
            sbBaseURL = baseUrl!;
        }
        
        
        if isNeedHUD {
            if waitingStatus == nil {
                progressView.show()
            }else{
                progressView.showWithStatus(waitingStatus)
            }
        }
        
        let url = sbBaseURL + "/" + apiName
        if isGet{
            Alamofire.request(url, method: .get, parameters: paramDic as? Dictionary, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization" : "Bearer " + getToke]).responseJSON(completionHandler: { (repooseData:DataResponse<Any>) in
                print("Net Request\(String(describing: repooseData.request))")  // original URL request
                print("Net Response\(String(describing: repooseData.response))") // URL response
                print("Net Data\(String(describing: repooseData.data))")     // server data
                print("Net Error\(String(describing: repooseData.result.error))")   // result of response serialization
                    
                    
                    if(repooseData.result.error == nil){
                            if isNeedHUD {
                                self.progressView.dismiss()
                            }
                            sucessBlockWay(repooseData.result.value! as AnyObject,apiName)
                    }else{
                        if failureStatus == nil {
                            self.progressView.showAlertViewWithStatus("网络出现问题，请检查网络。")
                        }else{
                            self.progressView.showAlertViewWithStatus(failureStatus!)
                        }
                        netFailureBlockWay(repooseData.result.error! as NSError)
                    }
                })
            
        }else{
            //"POST"
            
            Alamofire.request(url, method:.post,
                              parameters: paramDic as? Dictionary,
                encoding: JSONEncoding.default,
                headers: ["Authorization" : "Bearer " + getToke]).responseJSON(completionHandler: { (repooseData:DataResponse<Any>) in
                    
                    
                    print("Net Request\(String(describing: repooseData.request))")  // original URL request
                    print("Net Response\(String(describing: repooseData.response))") // URL response
                    print("Net Data\(String(describing: repooseData.data))")     // server data
                    print("Net Error\(String(describing: repooseData.result.error))")   // result of response serialization
                    
                    
                    if(repooseData.result.error == nil){
                            if isNeedHUD {
                                self.progressView.dismiss()
                            }
                            sucessBlockWay(repooseData.result.value! as AnyObject,apiName)
                        }else{
                        if failureStatus == nil {
                            self.progressView.showAlertViewWithStatus("网络出现问题，请检查网络。")
                            
                        }else{
                            self.progressView.showAlertViewWithStatus(failureStatus!)
                        }
                        netFailureBlockWay(repooseData.result.error! as NSError)
                    }
                })
            
            
        }
    }
    
}
