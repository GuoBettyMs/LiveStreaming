//
//  BaseVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/7.
//
/*
    汇总首页VC的标题栏 (4个)视图控制器，添加首页加载动画
 */

import UIKit

class BaseVC: UIViewController {

    // MARK: 定义属性
    var contentView: UIView?
    
    // MARK: 懒加载属性
    fileprivate lazy var animationImgV: UIImageView = { [unowned self] in
        let imgV = UIImageView(image: UIImage(named: "walk01"))
        imgV.center = self.view.center
        imgV.animationImages = [UIImage(named: "walk01")!, UIImage(named: "walk02")!, UIImage(named: "walk03")!, UIImage(named: "walk04")!]
        imgV.animationDuration = 0.5
        imgV.animationRepeatCount = LONG_MAX
        imgV.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        return imgV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //因imgV.autoresizingMask 不起作用，调整center.y使加载动画居中
        animationImgV.center.y = self.view.center.y - 100
    }

}

extension BaseVC{
    @objc func setUI(){
        //隐藏内容的view
        contentView?.isHidden = true
        
        view.addSubview(animationImgV)
        
        //执行动画
        animationImgV.startAnimating()
    }
    
    func loadDataFinished(){
        //停止动画
        animationImgV.stopAnimating()
        
        //隐藏animationImgV
        animationImgV.isHidden = true
        
        //显示内容的view
        contentView?.isHidden = false
        
    }
    
}
