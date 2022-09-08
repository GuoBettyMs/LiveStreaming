//
//  BaseViewModel.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//
/*
    首页VC的请求网络数据通用模型
 
 */
import UIKit

class BaseViewModel: NSObject {
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    
}

extension BaseViewModel{
    func laodAnchorData(isGroupData: Bool, URLString: String, parameters: [String: String]? = nil, finishCallback: @escaping () -> ()){
        NetworkTools.requestData(type: .GET, URLString: URLString, parameters: parameters) { result in
            //将result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //根据date 该key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {return}
            
            //判断是否分组
            if isGroupData {
                //遍历数组，字典转为模型对象
                for dict in dataArray {
                    self.anchorGroups.append(AnchorGroup(dict:dict))
                }
            }else{
                //创建组
                let group = AnchorGroup()
                
                //遍历dataArray 所有的字典
                for dict in dataArray {
                    group.anchors.append(AnchorModel(dict:dict))
                }
                
                //将group添加到anchorGroups
                self.anchorGroups.append(group)
            }

            finishCallback()            //完成回调
        }
    }
}
