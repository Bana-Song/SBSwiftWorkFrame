//
//  CustomImageView.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/12.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit
import Kingfisher

class CustomImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    /** 设置图片缓存配置 */
    func setKingfishSetting () {
        let downloader = KingfisherManager.shared.downloader;
        // 修改超时时间
        downloader.downloadTimeout = 20;
        
        let cache = KingfisherManager.shared.cache;
        // 设置硬盘最大缓存50M ，默认无限
        cache.maxDiskCacheSize = UInt(50 * 1024 * 1024)
        // 设置硬盘最大保存3天 ， 默认1周
        cache.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 3)
        cache.calculateDiskCacheSize { (size:UInt) in
            
        }
    }
    
    /** 设置图片 */
    func sbSetImageWithURL(url:String?) {
        self.kf.setImage(with: URL.init(string: url!));
//        self.sd_setImage(with: URL.init(string: url!));
    }
    
    /** 设置图片
     1.图片地址
     2.默认图片
     */
    func sbSetImageWithURL(url:String?,placeHolder:String?){
        self.kf.setImage(with: URL.init(string: url!), placeholder: UIImage.init(named: placeHolder!), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil);
//        self.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: placeHolder!));
    }
    
    
    /** 设置图片
     1.图片地址
     2.默认图片
     3.完成后回调
     */
    func sbSetImageURL(url:String?,placeHolder:String?,completeBlock:CompletionHandler?) {
        self.kf.setImage(with: URL.init(string: url!), placeholder: UIImage.init(named: placeHolder!), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: completeBlock);//        self.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: placeHolder!), completed: completeBlock);
    }
    
    /**
     缓存图片
     */
    func downLoadImageCache(url:String?,progerssBlock:ImageDownloaderProgressBlock?,completeBlock:ImageDownloaderCompletionHandler?) {
        
        let downloader = KingfisherManager.shared.downloader;
        downloader.downloadImage(with: URL.init(string: url!)!, options: [.transition(.fade(1))], progressBlock: progerssBlock, completionHandler: completeBlock);
//        let manager = SDWebImageManager.shared()
//        manager?.downloadImage(with: URL.init(string: url!), options: .retryFailed, progress: { (receiveSize:Int, exceptSize:Int) in
//            
//        }, completed: { (image:UIImage?, error:Error?, type:SDImageCacheType, finished:Bool, imgUrl:URL?) in
//            
//        })
    }
    
}
