//
//  CollectionPrettyCell.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/1.
//
/*
    首页VC的推荐界面 -> 主播界面的 特殊cell 模型
 
 */

import UIKit
import Kingfisher

class CollectionPrettyCell: CollectionBaseCell {


    @IBOutlet weak var cityBtn: UIButton!
    
    //定义模型类型
    override var anchor: AnchorModel?{
        didSet{
            //将属性传递给父类
            super.anchor = anchor
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }
    

}
