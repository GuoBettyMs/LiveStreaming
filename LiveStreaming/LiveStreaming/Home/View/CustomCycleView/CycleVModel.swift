//
//  CycleVModel.swift
//  LiveStreaming
//
//  Created by gbt on 2023/5/17.
//
/*
     无限轮播界面cell 模型(纯代码)
 */
import UIKit

class CycleVModel: NSObject {

    //标题
    @objc var title: String = ""
    
    //展示的图片地址
    @objc var img: String = ""
    
    //网站地址
    @objc var url: String = ""
    
    init(dict: [String: NSObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    //避免dict存在未定义的变量而报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
