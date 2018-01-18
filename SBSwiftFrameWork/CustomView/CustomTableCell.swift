//
//  CustomTableCell.swift
//  SBWorkFrameWork-Swift
//
//  Created by pg on 16/8/12.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

typealias swipeBlock = () -> Void
typealias deleteBlock = () -> Void
typealias cancleBlock = () -> Void

class CustomTableCell: UITableViewCell {

    //滑动属性
    var isOpen:Bool?
    var mySwipeBlock:swipeBlock?
    var myDeleteBlock:deleteBlock?
    
    //上下 滑线
    private var topView:UIView?
    private var bottomView:UIView?
    
    //自定义的滑动删除效果视图
    private var moveView:UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sbinit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sbinit () {
        self.topView = UIView();
        self.bottomView = UIView();
        self.moveView = UIView();
//        self.moveView?.backgroundColor = UIColor.red;
        self.moveView?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 44)
        self.moveView?.isUserInteractionEnabled = true;
        self.addSubview(self.moveView!)
    }
    
    //设置上滑线和下划线
    func setCustomLineColor(topLineColor:UIColor?,bottomLineColor:UIColor?,cellHeight:CGFloat,lineHeight:CGFloat) {
        if topLineColor != nil {
            self.topView?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: lineHeight);
            self.topView?.backgroundColor = topLineColor;
            self.addSubview(self.topView!);
        }
        if bottomLineColor != nil {
            self.bottomView?.frame = CGRect.init(x: 0, y: cellHeight - lineHeight, width: ScreenWidth, height: lineHeight);
            self.bottomView?.backgroundColor = bottomLineColor;
            self.addSubview(self.bottomView!)
        }
    }
    //设置下划线距离两边的空白距离
    func setCellBottomLineSpace(leftSpace:CGFloat,rightSpace:CGFloat) {
        var frame = self.bottomView!.frame;
        frame.origin.x = leftSpace;
        frame.size.width = ScreenWidth - leftSpace - rightSpace;
        self.bottomView!.frame = frame;
    }
    
    //设置自定滑动手势
    func setCustomSwipeDeleteAnimate () {
        let swipLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swip(swipe:)))
        swipLeft.direction = UISwipeGestureRecognizerDirection.left
        self.moveView?.addGestureRecognizer(swipLeft)
        
        let swipRight = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swip(swipe:)))
        swipRight.direction = UISwipeGestureRecognizerDirection.right
        self.moveView?.addGestureRecognizer(swipRight)
    }
    
    @objc func swip(swipe:UISwipeGestureRecognizer) {
        if swipe.direction == UISwipeGestureRecognizerDirection.left {
            openMenu();
            if( self.mySwipeBlock != nil){
                self.mySwipeBlock!();
            }

        }else{
            self .closeMenu()
        }
    }
    
    //开启滑动菜单
    func openMenu () {
        if self.isOpen == true {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.moveView?.center = CGPoint.init(x: (self.moveView?.center.x)! - 130, y: (self.moveView?.center.y)!)
        }, completion: { (finished:Bool) -> Void in
            if (finished) {
                self.isOpen = true;
            }
        })
    }
    
    //关闭滑动菜单
    func closeMenu () {
        if self.isOpen == false {
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.moveView?.center = CGPoint.init(x: ScreenWidth / 2, y: (self.moveView?.center.y)!)
        }, completion: { (finished:Bool) -> Void in
            if (finished) {
                self.isOpen = false;
            }
        })
    }
}
