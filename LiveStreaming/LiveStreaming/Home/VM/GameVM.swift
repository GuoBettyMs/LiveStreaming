//
//  GameVM.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC 的游戏界面的网络请求
 */
import UIKit

class GameVM: NSObject {

    lazy var games: [GameModel] = [GameModel]()
}

extension GameVM {
    func loadAllGameData(finishCallback: @escaping () -> ()){
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: ["short_name": "game"]) { result in
            //将result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else {return}
            
            //根据date 该key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {return}
            
            //遍历数组，字典转为模型对象
            for dict in dataArray {
                let model = GameModel(dict: dict)
                self.games.append(model)
            }
            
            finishCallback()            //完成回调
        }
    }
}
