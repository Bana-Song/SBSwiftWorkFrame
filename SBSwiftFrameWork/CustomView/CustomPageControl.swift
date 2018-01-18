//
//  CustomPageControl.swift
//  SBSwiftWorkFrame
//
//  Created by pg on 16/11/18.
//  Copyright © 2016年 Bana. All rights reserved.
//

import UIKit

enum SBPageControlAlignment {
    case SBPageControlAlignmentLeft,
    SBPageControlAlignmentCenter,
    SBPageControlAlignmentRight
}

enum SBPageControlVerticalAlignment {
    case SBPageControlVerticalAlignmentTop,
    SBPageControlVerticalAlignmentMiddle,
    SBPageControlVerticalAlignmentBottom
}

class CustomPageControl: UIControl {
    //private 请用set方法传值
    private var numberOfPages: Int = 0
    private var currentPage: Int = 0
    private var indicatorMargin:CGFloat = 10
    private var indicatorDiameter:CGFloat = 6
    var alignment:SBPageControlAlignment = .SBPageControlAlignmentCenter
    var verticalAlignment:SBPageControlVerticalAlignment = .SBPageControlVerticalAlignmentMiddle
    
    private var pageIndicatorImage:UIImage?
    var pageIndicatorTintColor:UIColor?// ignored if pageIndicatorImage is set
    
    private var currentPageIndicatorImage:UIImage?
    var currentPageIndicatorTintColor:UIColor? // ignored if currentPageIndicatorImage is set
    
    var hidesForSinglePage:Bool = false // hide the the indicator if there is only one page. default is NO
    var defersCurrentPageDisplay:Bool = false// if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO

    private var displayedPage:Int = 0
    private var measuredIndicatorWidth:CGFloat = 5.0
    private var measuredIndicatorHeight:CGFloat = 5.0
    private var pageImages:[String:UIImage]?
    private var currentPageImages:[String:UIImage]?
    
    func updateCurrentPageDisplay () {
        // update page display to match the currentPage. ignored if defersCurrentPageDisplay is NO. setting the page value directly will update immediately
        displayedPage = currentPage;
        self.setNeedsDisplay()
    }
    
    func rectForPageIndicator(pageIndex:Int)-> CGRect{
        if pageIndex < 0 || pageIndex >= numberOfPages {
            return CGRect.zero;
        }
        
        let left = leftOffset()
        let size = sizeForNumberOfPages(pageCount: pageIndex + 1);
        let rect = CGRect.init(x: left + size.width - measuredIndicatorWidth, y: 0, width: measuredIndicatorWidth, height: measuredIndicatorHeight)
        return rect;
    }
    
    func sizeForNumberOfPages(pageCount:Int) -> CGSize {
        let marginSpace = CGFloat(max(0, pageCount - 1)) * indicatorMargin;
        let indicatorSpace = CGFloat(pageCount) * measuredIndicatorWidth;
        return CGSize.init(width: marginSpace + indicatorSpace, height: measuredIndicatorHeight)
    }
    
    func setImageForPage(image:UIImage,pageIndex:Int) {
        setImageForPageCurrent(image: image, pageIndex: pageIndex, current: false)
    }
    
    func setCurrentImageForPage(image:UIImage,pageIndex:Int) {
        setImageForPageCurrent(image: image, pageIndex: pageIndex, current: true)
    }
    
    func imageForPage(pageIndex:Int) ->UIImage? {
        return imageForPageCurrent(pageIndex: pageIndex, current: false)
    }
    
    func currentImageForPage(pageIndex:Int) -> UIImage? {
        return imageForPageCurrent(pageIndex: pageIndex, current: true)
    }
    
    func updatePageNumberForScrollView(scrollView:UIScrollView) {
        let page = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        self.currentPage = page;
    }
    
    private func initialize () {
        numberOfPages = 0;
        self.backgroundColor = UIColor.clear;
        measuredIndicatorWidth = 5.0;
        measuredIndicatorHeight = 5.0;
        indicatorDiameter = 5.0;
        indicatorMargin = 13;
        pageImages = [String:UIImage]();
        currentPageImages = [String:UIImage]();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        renderPagesRect(context: context!, rect: rect)
    }
    
    override func sizeToFit() {
        var frame = self.frame
        var size = sizeForNumberOfPages(pageCount: numberOfPages)
        size.height = max(size.height, 36.0)
        frame.size = size;
        self.frame = frame;
    }
    
    private func renderPagesRect(context:CGContext,rect:CGRect) {
        if numberOfPages < 2 && hidesForSinglePage {
            return;
        }
        let left = leftOffset()
        var xOffset = left;
        let yOffset = topOffset()
        var fillColor:UIColor? = nil;
        var image:UIImage? = nil
        for i in 0..<numberOfPages {
            if i == displayedPage {
                fillColor = self.currentPageIndicatorTintColor != nil ? self.currentPageIndicatorTintColor : UIColor.white
                image = currentPageImages?[String(i)]
                if image == nil {
                    image = currentPageIndicatorImage
                }
            }else{
                fillColor = self.pageIndicatorTintColor != nil ? self.pageIndicatorTintColor:UIColor.white.withAlphaComponent(0.3)
                image = pageImages?[String(i)];
                if image == nil {
                    image = pageIndicatorImage
                }
            }
            fillColor?.set()
            if image != nil {
                image?.draw(at: CGPoint.init(x: xOffset, y: yOffset))
            }else{
                context.fillEllipse(in: CGRect.init(x: xOffset, y: yOffset, width: measuredIndicatorWidth, height: measuredIndicatorHeight))
            }
            xOffset += measuredIndicatorWidth + indicatorMargin
        }
    }
    
    private func imageForPageCurrent(pageIndex:Int,current:Bool)  -> UIImage? {
        if (pageIndex < 0 || pageIndex >= numberOfPages) {
            return nil;
        }
        
        var dictionary = current ? currentPageImages : pageImages;
        return dictionary?[String(pageIndex)]
    }
    
    private func setImageForPageCurrent(image:UIImage,pageIndex:Int,current:Bool) {
        if (pageIndex < 0 || pageIndex >= numberOfPages) {
            return;
        }
        
        var dictionary = current ? currentPageImages : pageImages;
        dictionary?[String(pageIndex)] = image;

    }
    
    private func leftOffset () -> CGFloat {
        let rect = self.bounds;
        let size = sizeForNumberOfPages(pageCount: numberOfPages)
        var left:CGFloat = 0.0
        switch alignment {
        case .SBPageControlAlignmentCenter:
            left = rect.midX - (size.width / 2.0)
            break
        case .SBPageControlAlignmentRight:
            left = rect.maxX - size.width
            break
        default:
            break
        }
        return left
    }
    
    private  func topOffset () -> CGFloat {
        let rect = self.bounds
        let size = sizeForNumberOfPages(pageCount: numberOfPages)
        var top:CGFloat = 0.0
        switch verticalAlignment {
        case .SBPageControlVerticalAlignmentMiddle:
            top = rect.midY - measuredIndicatorHeight / 2.0
            break
        case .SBPageControlVerticalAlignmentBottom:
            top = rect.maxY - size.height
            break
        default:
            break
        }
        return top
    }
    
    private func updateMeasuredIndicatorSizes () {
        measuredIndicatorWidth = indicatorDiameter;
        measuredIndicatorHeight = indicatorDiameter;
        if (self.pageIndicatorImage != nil && self.currentPageIndicatorImage != nil) {
            measuredIndicatorWidth = 0;
            measuredIndicatorHeight = 0;
        }
        
        if (self.pageIndicatorImage != nil) {
            let imageSize = self.pageIndicatorImage?.size;
            measuredIndicatorWidth = max(indicatorDiameter, (imageSize?.width)!);
            measuredIndicatorHeight = max(indicatorDiameter, (imageSize?.height)!);
        }
        
        if (self.currentPageIndicatorImage != nil) {
            let imageSize = self.currentPageIndicatorImage?.size;
            measuredIndicatorWidth = max(indicatorDiameter ,(imageSize?.width)!);
            measuredIndicatorHeight = max(indicatorDiameter, (imageSize?.height)!);
        }
    }
    
    //MARK: 监听事件
    func setIndicatorDiameter(indicatorDiameter:CGFloat) {
        
        if (indicatorDiameter == self.indicatorDiameter) {
            return;
        }
        
        self.indicatorDiameter = indicatorDiameter;
        updateMeasuredIndicatorSizes();
        self.setNeedsDisplay()

    }
    
    func setIndicatorMargin (indicatorMargin:CGFloat) {
        if (indicatorMargin == self.indicatorMargin) {
            return;
        }
        
        self.indicatorMargin = indicatorMargin;
        self.setNeedsDisplay()
    }
    
    func setNumberOfPages(currentPage:Int) {
        self.setCurrentPageEvent(currentPage: currentPage, sendEvent: false, defers: false)
    }
    
    
    func setCurrentPageEvent(currentPage:Int,sendEvent:Bool,defers:Bool) {
        if (currentPage < 0 || currentPage >= numberOfPages) {
            return;
        }
        
        self.currentPage = currentPage;
        if (false == self.defersCurrentPageDisplay || false == defers) {
            self.displayedPage = self.currentPage;
            self.setNeedsDisplay()
        }
        
        if (sendEvent) {
            self.sendActions(for: UIControlEvents.valueChanged)
        }
    }
    
    func setCurrentPageIndicatorImage(currentPageIndicatorImage:UIImage) {
        if (currentPageIndicatorImage.isEqual(self.currentPageIndicatorImage)) {
            return;
        }
        
        self.currentPageIndicatorImage = currentPageIndicatorImage;
        updateMeasuredIndicatorSizes()
        self.setNeedsDisplay()

    }
    
    func setPageIndicatorImage(pageIndicatorImage:UIImage) {
        if (pageIndicatorImage.isEqual(self.pageIndicatorImage)) {
            return;
        }
        
        self.pageIndicatorImage = pageIndicatorImage;
        updateMeasuredIndicatorSizes()
        self.setNeedsDisplay()
    }
}
