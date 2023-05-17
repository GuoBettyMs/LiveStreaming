//
//  RecommendCycleCell.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC 的推荐界面 -> 无限轮播界面cell
 */
import UIKit
import Kingfisher

class RecommendCycleCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    
    
    // MARK: 定义模型属性
    var cycleModel: CycleModel?{
        didSet{
            titleL.text = cycleModel?.title
            
            let iconURL = URL(string: cycleModel?.pic_url ?? "")!
            iconImgV.kf.setImage(with: iconURL, placeholder: UIImage(named: "logo"))
        }
    }
}
