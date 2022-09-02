//
//  AnchorGroup.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/1.
//
/*
    网络数据的 分组model 对象
 */

import UIKit

class AnchorGroup: NSObject {
    //分组对应的房间信息
    @objc var room_list: [[String: NSObject]]?{
        didSet{
            guard let room_list = room_list else {return}
            for dict in room_list{
                let model = AnchorModel(dict: dict)
                anchors.append(model)
            }
        }
    }
    @objc var tag_name: String = ""                    //分组标题
    @objc var small_icon_url: String = ""              //分组图标
    var header_icon_url: String = ""                   //自定义分组顶部view 图标
    lazy var anchors: [AnchorModel] = []               //定义主播的模型对象数组
    
    // MARK: 构造函数
    override init(){
        
    }
    
    init(dict: [String: NSObject]){
        super.init()
        self.setValuesForKeys(dict)
    }
    
    //避免dict存在未定义的变量而报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    /* 与didSet 写法作用相同
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataArray = value as? [[String: NSObject]] {
                for dict in dataArray{
                    anchors.append(AnchorModel(dict: dict))
                }
            }
        }
    }
    */
    
}
