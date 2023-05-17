//
//  CollectionBaseCell.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC的推荐界面的 通用cell 模型
 
 */


import UIKit
import Kingfisher

class CollectionBaseCell: UICollectionViewCell {

    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var onLineBtn: UIButton!
    @IBOutlet weak var nickNameL: UILabel!
    
    //定义模型类型
    var anchor: AnchorModel?{
        didSet{
            //校验模型是否有值
            guard let anchor = anchor else {return}
            
            //取出在线人数显示的文字
            var onlineStr: String = ""
            
            if anchor.online >= 10000{
                onlineStr = "\(Int(anchor.online / 10000)) 万在线"
            }else{
                onlineStr = "\(anchor.online) 在线"
            }
            onLineBtn.setTitle(onlineStr, for: .normal)

            nickNameL.text = anchor.nickname

            //设置封面图片
            guard let iconURL = URL(string: anchor.vertical_src) else {return}
            iconImgV.kf.setImage(with: iconURL as! Resource)

            
        }
    }
    
    
}
