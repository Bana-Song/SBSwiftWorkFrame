//
//  D3Model.swift
//  D3Model
//
//  Created by mozhenhau on 15/2/12.
//  Copyright (c) 2015年 mozhenhau. All rights reserved.
//

import Foundation

open class SBModel:NSObject{
    required override public init(){}
    //MARK: json转到model
    public class func jsonToModel<T>(dics:AnyObject?)->T!{
        if dics == nil {
            return nil
        }
        var dic:AnyObject!
        if dics is NSArray{
            dic = dics!.lastObject as AnyObject!
        }
        else{
            dic = dics
        }
        
        //get mirror
        let obj:AnyObject = self.init() //新建对象
        let properties:Mirror! = Mirror(reflecting: obj)
        
        if dic != nil{
            if let b = AnyBidirectionalCollection(properties.children) {
                for i in b {  //因为是继承NSO
                    let pro = i.value
                    var key = i.0;
                    let type = i.1;
          
                    switch type {
                    case (is Int),(is Int64),(is NSInteger):
                        let value = (dic.object(forKey: key!) as! NSString).integerValue
                        if value != nil{
                            obj.setValue(value, forKey: key!)
                        }
                        break
                        
                    case is Float,is Double,is Bool,is NSNumber:  //base type
                        let value: AnyObject! = dic.object(forKey: key!) as AnyObject
                        if value != nil{
                            obj.setValue(value, forKey: key!)
                        }
                        break
                        
                    case is String:
                        let value: AnyObject! = dic.object(forKey: key!) as AnyObject
                        if value != nil{
                            obj.setValue(value.description, forKey: key!)
                        }
                        break
                        
                    case is Array<String>:  //arr string
                        if let nsarray = dic.object(forKey: key!) as? NSArray {
                            var array:Array<String> = []
                            for el in nsarray {
                                if let typedElement = el as? String {
                                    array.append(typedElement)
                                }
                            }
                            obj.setValue(array, forKey: key!)
                        }
                        break
                        
                        
                    case is Array<Int>:   //arr int
                        if let nsarray = dic.object(forKey: key!) as? NSArray {
                            var array:Array<Int> = []
                            for el in nsarray {
                                if let typedElement = el as? Int {
                                    array.append(typedElement)
                                }
                            }
                            obj.setValue(array, forKey: key!)
                        }
                        break
//                    case is Array<Dictionary<String,AnyObject>>:
//                        let value = dic.object(forKey: key!) as AnyObject;
//                        if value is SBModel {
//                            obj.setValue((value as SBModel()).jsonToModelList(data: value), forKey: key!);
//                        }
//
//                        break;
//                    case is Dictionary<String,AnyObject>:
//                        let value = dic.object(forKey: key!) as AnyObject;
//                        if value is SBModel {
//                            obj.setValue((value as SBModel()).jsonToModel(dics: value), forKey: key!);
//                        }
//                        break;
                    default:     //unknow
                        let otherType = Mirror(reflecting: type).subjectType
                        
                        switch otherType{
                        case is Optional<String>.Type,is Optional<NSNumber>.Type,is Optional<NSInteger>.Type,is Optional<Array<String>>.Type,is Optional<Array<Int>>.Type:
                            obj.setValue(dic.object(forKey: key!), forKey: key!)
                            break
                            
                        default:
//                            let name:String = String(describing: otherType)
//                            let className = getClassName(name: name as NSString) as String
//                            let clz:AnyClass! = NSClassFromString(className)
//                            
//                            if clz != nil{
//                                if let data = dic.object(forKey: key!) as? NSArray{
//                                    let value = clz.jsonToModelList(data: data);
////                                        clz.jsonToModelList(data)
//                                    obj.setValue(value, forKey: key!)
//                                }
//                                else{
//                                    let value = dic.object(forKey: key!) as AnyObject;
//                                    let setValue = (clz as! SBModel.Type).jsonToModel(dics: value)
////                                    (clz as! SBModel.Type).jsonToModel(dics: value)
//                                    obj .setValue("sd", forKey: "sd");
//                                }
//                            }
//                            else{
//                                print("unknown property")
//                            }
                            break
                        }
                    }
                }
            }else{
                return nil;
            }
        }
        
        return (obj as! T)
    }
    
    //MARK: json转到model list,传入anyobject
    public class func jsonToModelList(data:AnyObject?)->Array<AnyObject>{
        if data == nil{
            return []
        }
        
        var objs:Array<AnyObject> = []
        if let dics = data as? NSArray{
            for  i in 0 ..< dics.count {
                let dic:AnyObject = dics[i] as AnyObject
                objs.append(jsonToModel(dics: dic) as AnyObject)
            }
        }
        return objs
    }
    
    
    //从一串Optional<*******>找到类名字符串
    private class func getClassName(name:NSString)->NSString!{
        var range = name.range(of: "<.*>", options: String.CompareOptions.regularExpression);
//        NSString.CompareOptions.RegularExpressionSearch
        if range.location != NSNotFound{
            range.location += 1
            range.length -= 2
            return getClassName(name: name.substring(with: range) as NSString);
        }
        else{
            return name
        }
    }

}
