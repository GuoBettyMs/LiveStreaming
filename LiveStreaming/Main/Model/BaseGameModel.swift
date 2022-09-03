//
//  BaseGameModel.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC 的游戏数据 通用模型
 
 */
import UIKit

class BaseGameModel: NSObject {
    
    // MARK: 定义属性
    @objc var tag_name: String = ""
    @objc var icon_url: String = ""

    // MARK: 构造函数
    override init(){
        
    }
    
    // MARK: 自定义构造函数
    init(dict: [String: Any]){
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
