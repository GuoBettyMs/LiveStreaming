//
//  CollectionGameCell.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    
    
    // MARK: 定义模型属性
    var baseGame: BaseGameModel?{
        didSet{
            titleL.text = baseGame?.tag_name

            if let iconURL = URL(string: baseGame?.icon_url ?? "") {
                iconImgV.kf.setImage(with: iconURL)
            }else{
                iconImgV.image = UIImage(named: "walk04")
            }
            
                
        }
    }


}
