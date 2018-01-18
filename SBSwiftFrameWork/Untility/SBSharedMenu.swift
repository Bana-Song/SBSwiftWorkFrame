//
//  SBSharedMenu.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/10.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit
import Kingfisher

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


//MARK: 系统方法
/* 系统相关 */
let ScreenWidth = UIScreen.main.bounds.size.width;//屏幕宽度
let ScreenHeight = UIScreen.main.bounds.size.height;//屏幕高度
let SystemVersion = Float(UIDevice.current.systemVersion);//系统版本
let isSystemVersion9 = Float(UIDevice.current.systemVersion) > 9.0 ? 1:0;//判断系统版本


/* 常用正则 */
let mailRegex  = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" //邮箱
let userNameRegex  = "^[a-z0-9_-]{6,20}$" //用户名 字母加数字
let phonenumRegex = "^1[0-9]{10}$" //电话
let httpUrlRegex = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$" //网址
let ipRegex = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$" //ip地址
let passWordRegex = "^[a-zA-Z0-9_\\u4e00-\\u9fa5]+$" //密码
let IDCardRegex = "\\d{15}|\\d{18}" //身份证号国内



//颜色值定义 RGB 模式

func SBColorWithRGV(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: a);
}

//颜色值 十六进制模式
func SBColorWith0xRGB(_ rgbValue:UInt,a:CGFloat) -> UIColor {
    return UIColor.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(a / 1.0));
}


//自定义日志
func SBLog(_ any:String) {
    #if DEBUG
        print(any)
    #endif
}

//自定义日志 －－－－ 为了DEBUG状态下的测试日志
func SBLogD<T>(message:T,file : String = #file, funcName : String = #function, lineNum : Int = #line){
    #if DEBUG
        // 需要在 buildSetting 中配置 swift flags的参数为:-D DEBUG, DEBUG可以自定义, 一般用 DEBUG
        // 搜 swift flags-->other swift flags-->DEBUG-->点+号-->输入上面的配置参数
        // 1.对文件进行处理
        let fileName = (file as NSString).lastPathComponent
        
        // 2.打印内容
        print("[\(fileName)][\(funcName)](\(lineNum)):\(message)")
    #endif
}



/**
 保存本地模型
 */
func SBSaveLocalModel(_ userModel:SBUserInfoModel) {
    let userDefault = UserDefaults.standard
    
    let modelData:Data = NSKeyedArchiver.archivedData(withRootObject: userModel)
    userDefault.set(modelData, forKey: "SBUserInfoModel");
}


/**
 获取本地存储模型
 */
func SBGetLocalModel() -> SBUserInfoModel {
    let userDefault = UserDefaults.standard
    let myModelData = userDefault.object(forKey: "SBUserInfoModel") as? Data
    
    if(myModelData == nil){
        return SBUserInfoModel();
    }
    let myModel = NSKeyedUnarchiver.unarchiveObject(with: myModelData!)
    
    return  myModel as! SBUserInfoModel
}

/**
 清除缓存
 1.Document目录
 2.SDWebImage缓存的图片
 3.Caches目录
 */
func clearCache () {
   DispatchQueue.global().async {
    let cachePath  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first;
    removeFileWithPath(cachePath!);
    let cachePath2  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first;
    removeFileWithPath(cachePath2!);
    
    //清理图片缓存
    let cache = KingfisherManager.shared.cache;
    //清理内存缓存
    cache.clearMemoryCache()
    
    // 清理硬盘缓存，这是一个异步的操作
    cache.clearDiskCache()
    
    // 清理过期或大小超过磁盘限制缓存。这是一个异步的操作
    cache.cleanExpiredDiskCache()
    }
}

/**
 删除文件夹下的所有文件
 */
func removeFileWithPath(_ folderPath:String){
    let fileManager = FileManager.default;
    let contents = try! fileManager.contentsOfDirectory(atPath: folderPath) as NSArray
    let enums = contents.objectEnumerator()
    var fileName = "";
    while (!(enums.nextObject() as! String).isEmpty) {
        fileName = enums.nextObject() as! String;
        try! fileManager.removeItem(atPath: fileName)
    }
    
}

/** 
 缓存图片
 */

func saveToCache(url:String,image:UIImage) {
    let cache = KingfisherManager.shared.cache;
    cache.store(image, forKey: url);
}

/**
 根据url获取缓存图片
 */
func cacheImgWithURL(url:String) -> UIImage {
    let cache = KingfisherManager.shared.cache;
    let imgPath = cache.cachePath(forKey: url);
    let img = UIImage.init(contentsOfFile: imgPath);
    return img!;
}
/**
 应用版本
 */
func appVersion () -> String {
    let infoDic = Bundle.main.infoDictionary;
    return infoDic!["CFBundleShortVersionString"] as! String;
}
/**
 应用名称
 */
func appName () -> String {
    let infoDic = Bundle.main.infoDictionary;
    return infoDic!["CFBundleDisplayName"] as! String;
}

/**
 序列号
 */
func identifierNumber() -> String {
    return (UIDevice.current.identifierForVendor?.uuidString)!;
}


/**
 系统版本
 */
func appSystemVersion() -> CGFloat{
    return CGFloat((UIDevice.current.systemVersion as NSString).floatValue);
}



//MARK: 私有公共方法

class SBSharedMenu: NSObject {
    
    /** 单例模式 */
    struct Static {
        static var onceToken: Int = 0
        static var instance: SBSharedMenu? = nil
    }

    private static var __once: () = { () -> Void in
        Static.instance = SBSharedMenu()
    }()
    class var sharedInstance: SBSharedMenu {
        _ = SBSharedMenu.__once
        return Static.instance!
    }
    
    func getStringWidth(content:String,fontSize:CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize);
        let rect = (content as NSString).boundingRect(with: CGSize.init(width: ScreenWidth, height: ScreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil);
        return rect.size.width;
    }
    
    func getStringHeight(content:String,fontSize:CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize);
        let rect = (content as NSString).boundingRect(with: CGSize.init(width: ScreenWidth, height: ScreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil);
        return rect.size.height;
    }
    
    func createQcodeWithURL(url:String) -> UIImage {
        var resultImg = UIImage.init();
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator");
        // 2.还原滤镜默认属性
        filter?.setDefaults();
        // 3.设置需要生成二维码的数据到滤镜中
        // OC中要求设置的是一个二进制数据

        let data = url.data(using: String.Encoding.utf8);
        filter?.setValue(data, forKey: "InputMessage");
        
        // 4.从滤镜从取出生成好的二维码图片
        let ciImage = filter?.outputImage;
        if ciImage != nil {
            resultImg = self.createNonInterpolatedUIImageFormCIImage(ciImage: ciImage!, widthAndHeight: 108);
        }
        return resultImg;
    
    }
    
    //保存二维码为高清图片
    func createNonInterpolatedUIImageFormCIImage(ciImage:CIImage,widthAndHeight:CGFloat) -> UIImage {
        let extentRect = ciImage.extent.integral;
        let scale = CGFloat.minimum(widthAndHeight / extentRect.width, widthAndHeight / extentRect.height);
        
        // 1.创建bitmap;
        let width = extentRect.width * scale;
        let height = extentRect.height * scale;
        let cs = CGColorSpaceCreateDeviceGray();
        var bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0);
            
            //CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
        
        let context = CIContext.init();
        
        var bitmapImage = context.createCGImage(ciImage, from: extentRect);
//            [context createCGImage:ciImage fromRect:extentRect];
        bitmapRef!.interpolationQuality = CGInterpolationQuality(rawValue: 0)!;
        bitmapRef!.scaleBy(x: scale, y: scale);
        bitmapRef?.draw(bitmapImage!, in: extentRect);
        
        // 保存bitmap到图片
        let scaledImage = bitmapRef?.makeImage();
        bitmapRef = nil;
        bitmapImage = nil;
        
        return UIImage.init(cgImage: scaledImage!); // 黑白图片
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    
}
