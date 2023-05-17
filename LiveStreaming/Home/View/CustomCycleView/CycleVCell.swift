//
//  CycleVCell.swift
//  LiveStreaming
//
//  Created by gbt on 2023/5/17.
//

import UIKit
import Kingfisher

class CycleVCell: UICollectionViewCell {
    
    let bgImgV = UIImageView()
    let titleL = UILabel()
    
    // MARK: 定义模型属性
    var cycleModel: CycleVModel?{
        didSet{
            titleL.text = cycleModel?.title
            
            let iconURL = URL(string: cycleModel?.img ?? "")!
            bgImgV.kf.setImage(with: iconURL, placeholder: UIImage(named: "LogoLIcon"))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(bgImgV)
//        bgImgV.addSubview(titleL)

        /*
          pod 'SnapKit', '~> 5.6.0'
         bgImgV.snp.makeConstraints { make in
             make.width.equalToSuperview()
             make.height.equalToSuperview()
             make.top.equalToSuperview()
             make.centerX.equalToSuperview()
         }
         */

//        titleL.snp.makeConstraints { make in
//            make.bottom.equalTo(bgImgV.snp.bottom)
//            make.centerX.equalToSuperview()
//        }
//        titleL.font = UIFont.systemFont(ofSize: 18)
//        titleL.textColor = .black
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

