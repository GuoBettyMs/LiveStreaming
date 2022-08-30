//
//  BarBtnItemEx.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/19.
//
/*
    重写 UIBarButtonItem，重新设置 BarButtonItem 样式
 
 */

import UIKit

extension UIBarButtonItem{
    
    /* 类方法
    class func createItem(imgName: UIImage, highImgName: UIImage, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(imgName, for: .normal)
        btn.setImage(highImgName, for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
     */
    
    // MARK: 便利构造函数,必须明确调用一个设计的构造函数
    convenience init(imgName: UIImage, highImgName: UIImage! = nil, size: CGSize = CGSize.zero){
        let btn = UIButton()
        btn.setImage(imgName, for: .normal)
        if highImgName != nil {
            //.withTintColor(.red).withRenderingMode(.alwaysOriginal)  保持原始图片的红色色调
            btn.setImage(highImgName.withTintColor(.red).withRenderingMode(.alwaysOriginal), for: .highlighted)
        }
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)
    }
    
}
