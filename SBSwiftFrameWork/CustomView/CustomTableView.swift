//
//  CustomTableView.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/12.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit
import MJRefresh

class CustomTableView: UITableView {
    
    fileprivate var sbPullBlock:sbRefreshPullBlock?
    fileprivate var sbPushBlock:sbRefreshPushBlock?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: 自定义方法
    
    func addRefreshController(type:TableRefrehType,pullBlock:sbRefreshPullBlock?,pushBlock:sbRefreshPushBlock?){
        sbPullBlock = pullBlock;
        sbPushBlock = pushBlock;
        switch type {
        case .tDefault:
            break;
        case .tUpPull:
            self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.PullMethod));
            break;
        case .tDownPull:
            self.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.PushMethod));
            break;
        case .tAllPull:
            self.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.PullMethod));
            self.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.PushMethod));
            break;
        default:
            break;
        }
    }
    
    
    @objc func PullMethod () {
        sbPullBlock!();
        self.mj_header.endRefreshing();
    }
    
    @objc func PushMethod() {
        sbPushBlock!();
        self.mj_footer.endRefreshing();
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
