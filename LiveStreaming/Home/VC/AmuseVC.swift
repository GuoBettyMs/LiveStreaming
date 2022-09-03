//
//  AmuseVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//
/*
    首页VC 的娱乐界面 collectionView
     a. 游戏Icon界面
     b. 主播界面
 */

import UIKit

private let kMenuViewH: CGFloat = 200


class AmuseVC: BaseAnchorVC {

    fileprivate lazy var amuseVM: AmuseVM = AmuseVM()
    fileprivate lazy var menuView: AmuseMenuView = {
        let menuView = AmuseMenuView.amuseMenuView()
        menuView.frame = CGRect(x: 0, y: -kMenuViewH, width: kScreenW, height: kMenuViewH)
        return menuView
    }()
}


extension AmuseVC{
    override func setUI(){
        super.setUI()
        collectionV.addSubview(menuView)
        
        //给collectionV 添加内边距
        collectionV.contentInset = UIEdgeInsets(top: kMenuViewH, left: 0, bottom: 0, right: 0)
    }
}


extension AmuseVC{
    override func loadDate(){
        //给父类中ViewModel 进行赋值
        baseVM = amuseVM
        
        //请求网络数据
        amuseVM.loadAmuseData {
            self.collectionV.reloadData()
            
            var tempGroups = self.amuseVM.anchorGroups
            tempGroups.remove(at: 0)
            self.menuView.groups = tempGroups
        }
    }
}



