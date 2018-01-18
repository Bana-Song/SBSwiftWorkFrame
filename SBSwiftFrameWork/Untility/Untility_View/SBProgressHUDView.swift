//
//  SBProgressHUDView.swift
//  innjia.ios.landlord
//
//  Created by ftit on 16/4/1.
//  Copyright © 2016年 cz-user2. All rights reserved.
//

import UIKit
import SVProgressHUD



class SBProgressHUDView: NSObject {
    
    struct Static {
        static var onceToken: Int = 0
        static var instance: SBProgressHUDView? = nil
    }
    
    private static var __once: () = { () -> Void in
            Static.instance = SBProgressHUDView()
            SVProgressHUD.setDefaultMaskType(.black);
        }()
    /** 单例模式 */
    class var sharedInstance: SBProgressHUDView {
        _ = SBProgressHUDView.__once
        return Static.instance!
    }
    
    
    /** 没有提示的转圈 */
    func show(){
        SVProgressHUD.show()
    }
    /** 有提示的转圈 */
    func showWithStatus(_ status:String!) {
        SVProgressHUD.show(withStatus: status)
        
    }
    /** 成功提示 */
    func showSucessWithStatus(_ status:String){
        SVProgressHUD.showSuccess(withStatus: status)
    }
    /** 错误提示 */
    func showErrorWithStatus(_ status:String){
        SVProgressHUD.showError(withStatus: status)
    }
    /** 隐藏 */
    func dismiss(){
        SVProgressHUD.dismiss()
    }
    /** alertView */
    func showAlertViewWithStatus(_ status:String){
        SVProgressHUD.dismiss()
        SBAlertView().show(["好的"], title: nil, message: status)
    }}
