//
//  FunVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//
/*
    首页VC 的趣玩界面  collectionView
 a. 主播房间界面
 */
import UIKit

private let kTopMargin: CGFloat = 10

class FunVC: BaseAnchorVC {
    // MARK: 懒加载 VM对象
    fileprivate lazy var funnyVM: FunVM = FunVM()
}

extension FunVC{
    override func setUI() {
        super.setUI()
        
        let layout = collectionV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionV.contentInset = UIEdgeInsets(top: kTopMargin, left: 0, bottom: 0, right: 0)

    }

}

extension FunVC{
    override func loadDate() {
        //给父类中的view赋值
        baseVM = funnyVM
        
        funnyVM.loadFunData {
            self.collectionV.reloadData()
        }
        
    }
}
