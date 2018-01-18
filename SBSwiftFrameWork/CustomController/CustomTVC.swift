//
//  CustomTVC.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/11.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit
import MJRefresh

enum TableRefrehType{
    case tDefault //没有刷新功能
    case tUpPull //上拉刷新
    case tDownPull //下拉刷新
    case tAllPull //上下拉刷新
}

typealias sbRefreshPullBlock =  () -> Void
typealias sbRefreshPushBlock =  () -> Void

class CustomTVC: UITableViewController {

    fileprivate var sbPullBlock:sbRefreshPullBlock?
    fileprivate var sbPushBlock:sbRefreshPushBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    //MARK: 自定义方法
    
    func addRefreshController(_ type:TableRefrehType,pullBlock:sbRefreshPullBlock?,pushBlock:sbRefreshPushBlock?){
        sbPullBlock = pullBlock;
        sbPushBlock = pushBlock;
        switch type {
        case .tDefault:
            break;
        case .tUpPull:
            self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.PullMethod));
            break;
        case .tDownPull:
            self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.PushMethod));
            break;
        case .tAllPull:
            self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.PullMethod));
            self.tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.PushMethod));
            break;
        default:
            break;
        }
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

    @objc func PullMethod () {
        sbPullBlock!();
        self.tableView.mj_header.endRefreshing();
    }
    
    @objc func PushMethod() {
        sbPushBlock!();
        self.tableView.mj_footer.endRefreshing();
    }

}
