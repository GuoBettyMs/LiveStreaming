//
//  AnchorModel.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/1.
//

import UIKit

class AnchorModel: NSObject {

    @objc var room_id: Int = 0                      //主播房间id
    @objc var vertical_src: String = ""             //主播房间对应的URLString
    @objc var isVertical: Int = 0                   //直播类型，电脑为0，手机为1
    @objc var room_name: String = ""                //主播房间名
    @objc var nickname: String = ""                 //主播昵称
    @objc var online: Int = 0                       //观看人数
    @objc var anchor_city: String = ""              //所在城市
    
    init(dict: [String: NSObject]){
        super.init()
        
        setValuesForKeys(dict)
    }
    
    //避免dict存在未定义的变量而报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
