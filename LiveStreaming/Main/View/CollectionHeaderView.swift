//
//  CollectionHeaderView.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/31.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    
    var group: AnchorGroup? {
        didSet{
            titleL.text = group?.tag_name
            
            let imgString = group?.header_icon_url != "" ? group?.header_icon_url : "walk03"
            iconImgV.image = UIImage(named: imgString!)

        }
    }
    
}
