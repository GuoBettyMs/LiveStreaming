//
//  RecommendVM.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/1.
//
/*
    首页VC 的推荐界面的网络请求
 */


import UIKit

class RecommendVM: BaseViewModel {
    //总分组数据
    lazy var cycleModels: [CycleModel] = [CycleModel]()
    
    private lazy var bigDataGroup: AnchorGroup = AnchorGroup()
    private lazy var prettyGroup: AnchorGroup = AnchorGroup()
   
}

extension RecommendVM {
    
    // MARK: 请求推荐数据
    func requestData(finishCallback: @escaping () -> ()){
        
        let parameters = ["time": NSDate.getCurrntTime(), "limit": "4", "offset": "0"]
        
        //创建线程分组 DispatchGroup
        let dispatchGroup = DispatchGroup()
        
        //请求第0组的游戏数据
        dispatchGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time": NSDate.getCurrntTime()]) { result in
            
            //将result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //根据date 该key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {return}
            
            //遍历数组，并且转为模型对象
            //设置分组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.header_icon_url = "walk01"
            
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            //离开组
            dispatchGroup.leave()
        }
        
        
        //请求第1组的游戏数据
        dispatchGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { result in
            
            //将result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //根据date 该key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {return}
            
            //遍历数组，并且转为模型对象
            //设置分组的属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.header_icon_url = "walk02"
            
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            
            //离开组
            dispatchGroup.leave()
        }
        
        
        //请求第2-12组的游戏数据
        dispatchGroup.enter()
        laodAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) {
            
            //离开组
            dispatchGroup.leave()
        }
        

        //所有数据都请求到后，进行排序
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)

            finishCallback()
        }
    }
    
    // MARK: 请求无限轮播数据
    func requestCycleData(finishCallback: @escaping () -> ()){
        NetworkTools.requestData(type: .GET, URLString: "http:/www.douyutv.com/api/v1/slide/6", parameters: ["version": "2.300"]) { result in
            //将result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //根据date 该key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {return}
            
            //遍历数组，字典转为模型对象
            for dict in dataArray {
                let anchor = CycleModel(dict: dict)
                self.cycleModels.append(anchor)
            }
            
            finishCallback()
        }
        
    }
    
}
