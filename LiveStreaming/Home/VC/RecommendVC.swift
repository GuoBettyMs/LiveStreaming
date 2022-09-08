//
//  RecommendVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/31.
//
/*
    首页VC 的推荐界面
 (1) 推荐界面  collectionView
      a. 无限轮播界面
      b. 游戏Icon界面
      c. 主播界面 RecommendVC
 */


import UIKit
import Alamofire

private let kItemMargin: CGFloat = 10                               //推荐界面的item边距
private let kItemW = (kScreenW - 3 * kItemMargin) / 2               //推荐界面的item宽度
private let kNormalItemH = kItemW * 3 / 4                           //推荐界面的一般item高度
private let kPrettyItemH = kItemW * 4 / 3                           //推荐界面的特殊item高度
private let kCycleViewH = kScreenW * 3 / 8                          //无限轮播界面的高度
private let kGameViewH: CGFloat = 90                                //游戏Icon界面的高度

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class RecommendVC: BaseAnchorVC {

    // MARK: 网络请求懒加载属性
    private lazy var recommendVM: RecommendVM = RecommendVM()
    
    // MARK: 无限轮播界面懒加载
    private lazy var cycleView: RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH - kGameViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    // MARK: 游戏Icon界面懒加载
    private lazy var gameV: RecommendGameV = {
        let gameV = RecommendGameV.recommendGameV()
        gameV.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameV
    }()

}


extension RecommendVC{
    override func setUI(){
        //先调用super.init()
        super.setUI()
        
        collectionV.addSubview(cycleView)
        collectionV.addSubview(gameV)
        
        //添加头部内边距 kCycleViewH 是无限轮播界面显示； kGameViewH 是游戏Icon界面显示
        //由于collectionView 底部被遮挡，添加autoresizingMask不起作用，因此添加底部内边距 kNormalItemH
        collectionV.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: kNormalItemH, right: 0)
    }
}

// MARK: 请求数据
extension RecommendVC{
    override func loadDate(){
        //给父类中ViewModel 进行赋值
        baseVM = recommendVM
        
        //请求推荐数据
        recommendVM.requestData {
            self.collectionV.reloadData()
            
            //将数据传递给GameV
            var groups = self.recommendVM.anchorGroups
            
            //移除前两组数据
            groups.remove(at: 0)
            groups.remove(at: 0)
            
            //添加“更多”分组
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            
            self.gameV.groups = groups
            
            //数据请求完成
            self.loadDataFinished()
        }
        
        //请求无限轮播数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
        
    }
}

// MARK: 遵守 UICollectionViewDataSource 、 UICollectionViewDelegate
extension RecommendVC {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //取出模型对象
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]

        //定义 cell
        var cell: CollectionBaseCell!
        if indexPath.section == 1{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)  as! CollectionViewCell
        }
        cell.anchor = anchor
        return cell
    }
}

// MARK: 遵守 UICollectionViewDelegateFlowLayout
extension RecommendVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        return CGSize(width: kItemW, height: kNormalItemH)
    }

}
