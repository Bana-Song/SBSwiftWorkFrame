
import UIKit

protocol SBAlertViewDelegate {
    func sbAlertDidSelectedIndex(_ index:NSInteger,andAction:NSString);
}


class SBAlertView: UIView {
    
    
    var delegate:SBAlertViewDelegate?
    
    fileprivate let mainView:UIView = UIView();
    fileprivate let titleLabel:UILabel = UILabel();
    fileprivate let messageLabel:UILabel = UILabel();
    fileprivate var actions:Array<String> = [String]();
    fileprivate let lineView:UIView = UIView();
    
    
    let mainWith : CGFloat  = 300;
    
    func show(_ actionArray:Array<String>,title:String?,message:String?){
        initView()
        titleLabel.text = title;
        messageLabel.text = message;
        
        if title == nil {
            lineView.isHidden = true;
        }
        
        let rect = (message! as NSString).boundingRect(with: CGSize(width: 80, height: 300), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil)
        messageLabel.textAlignment = .center;
         messageLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 1, width: mainWith, height: rect.size.height);
        messageLabel.numberOfLines = 0;
        
        if actionArray.count > 0 {
            actions = actionArray;
            mainView.frame = CGRect(x: 0, y: 0, width: mainWith, height: rect.size.height + 81);
        }else{
            mainView.frame = CGRect(x: 0, y: 0, width: mainWith, height: rect.size.height + 41);
        }
        mainView.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2 - 100);
        
        addButtons(actionArray)
        UIApplication.shared.keyWindow!.addSubview(self)

    }
    
    func initView () {
        self.frame = UIScreen.main.bounds;
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3);
        mainView.backgroundColor = UIColor.white
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: mainWith, height: 40);
        titleLabel.backgroundColor = UIColor.white;
        titleLabel.textAlignment = .center;
        mainView.addSubview(titleLabel);
        
        lineView.frame = CGRect(x: 0, y: 40 , width: mainWith, height: 1);
        lineView.backgroundColor = UIColor.lightGray;
        mainView.addSubview(lineView)
        
        messageLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 1, width: mainWith, height: 1);
        messageLabel.backgroundColor = UIColor.clear;
        mainView.addSubview(messageLabel);
        
        self.addSubview(mainView);
    }
    
    func addButtons (_ actions:Array<String>) {
        let width = (mainWith / CGFloat(actions.count));
        var x:CGFloat = 0.0;
        for index in 0..<actions.count {
            x = CGFloat(index) * width;
            let btn = UIButton.init(frame: CGRect(x: x , y: messageLabel.frame.maxY, width: width, height: 40));
            btn.setTitle(actions[index], for: UIControlState());
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14);
            btn.backgroundColor = UIColor.clear;
            btn.setTitleColor(UIColor.black, for: UIControlState())
            btn.tag = index;
            
            btn.addTarget(self, action: #selector(clickBtn(_:)), for: UIControlEvents.touchUpInside);
            mainView.addSubview(btn);
        }
    }
    
    @objc func clickBtn (_ sender:UIButton) {
        let title = actions[sender.tag];
        if title ==  "取消" || sender.tag == 0{
            actions = [String]();
            self.removeFromSuperview()
            return;
        }
        if self.delegate != nil {
            self.delegate?.sbAlertDidSelectedIndex(sender.tag, andAction: title as NSString);
        }
        actions = [String]();
        self.removeFromSuperview()
        
    }
    
}
