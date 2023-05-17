//
//  CollectionHeaderView.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/31.
//
/*
    首页VC 的推荐界面 -> 主播界面的头部View
 */


import UIKit

class CollectionHeaderView: UICollectionReusableView {

    
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    var group: AnchorGroup? {
        didSet{
            titleL.text = group?.tag_name
            
            let imgString = group?.header_icon_url != "" ? group?.header_icon_url : "walk03"
            iconImgV.image = UIImage(named: imgString!)

        }
    }
    
}

// MARK: 从xib中快速创建的类方法
extension CollectionHeaderView{
    class func collectionHeaderView() -> CollectionHeaderView{
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
