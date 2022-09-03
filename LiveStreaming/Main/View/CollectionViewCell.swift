//
//  CollectionViewCell.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/31.
//
/*
    首页VC的推荐界面 -> 主播界面的一般cell 模型
 
 */
import UIKit
import Kingfisher

class CollectionViewCell: CollectionBaseCell {


    @IBOutlet weak var roomnameL: UILabel!
    
    
    //定义模型类型
    override var anchor: AnchorModel?{
        didSet{
            //将属性传递给父类
            super.anchor = anchor
            roomnameL.text = anchor?.room_name
        }
    }
    

}
