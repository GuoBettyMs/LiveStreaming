//
//  CycleModel.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//

import UIKit

class CycleModel: NSObject {

    //标题
    @objc var title: String = ""
    
    //展示的图片地址
    @objc var pic_url: String = ""
    
    //主播信息对应的模型对象
    @objc var anchor: AnchorModel?
    
    //主播信息对应的字典
    @objc var room: [String: NSObject]?{
        didSet{
            guard let room = room else {return }
            anchor = AnchorModel(dict: room)
        }
    }
    
    init(dict: [String: NSObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    //避免dict存在未定义的变量而报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
