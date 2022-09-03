//
//  GameVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC 的游戏界面
 (1) 推荐界面  collectionView
     a. 常用游戏Icon界面 （10个）
     b. 全部游戏Icon界面
 */

import UIKit

private let kEdgeMargin: CGFloat = 10                                           //全部游戏Icon界面的边距
private let kItemW: CGFloat = (kScreenW - 2 * kEdgeMargin) / 3                  //全部游戏Icon界面的宽度
private let kItemH: CGFloat = kItemW * 6 / 5                                    //全部游戏Icon界面的高度
private let kHeaderViewH: CGFloat = 50                                          //全部游戏Icon界面头部View的高度
private let kCommonGameViewH: CGFloat = 90                                          //常用游戏Icon界面头部View的高度

private let kGameCellID = "kGameCellID"
private let kHeaderViewID = "kHeaderViewID"

class GameVC: UIViewController {

    
    fileprivate lazy var gameVM: GameVM = GameVM()
    
    // MARK: 常用游戏Icon界面懒加载
    fileprivate lazy var topHeaderView: CollectionHeaderView = {
        let headerView = CollectionHeaderView.collectionHeaderView()
        headerView.frame = CGRect(x: 0, y: -kHeaderViewH - kCommonGameViewH, width: kScreenW, height: kHeaderViewH)
        headerView.titleL.text = "常见"
        headerView.iconImgV.image = UIImage(systemName: "poweron")?.withTintColor(.red).withRenderingMode(.alwaysOriginal)
        headerView.moreBtn.isHidden = true
        return headerView
    }()
    
    fileprivate lazy var gameView: RecommendGameV = {
        let gameV = RecommendGameV.recommendGameV()
        gameV.frame = CGRect(x: 0, y: -kCommonGameViewH, width: kScreenW, height: kCommonGameViewH)
        return gameV
        
    }()
    
    // MARK: 全部游戏Icon界面懒加载
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdgeMargin, bottom: 0, right: kEdgeMargin)
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        loadData()

    }

}

extension GameVC{
    private func setUI(){
        view.addSubview(collectionView)
        collectionView.addSubview(topHeaderView)
        collectionView.addSubview(gameView)
        //给collectionV 添加内边距
        collectionView.contentInset = UIEdgeInsets(top: kHeaderViewH + kCommonGameViewH, left: 0, bottom: 0, right: 0)
    }
}


extension GameVC{
    // MARK: 请求网络数据
    fileprivate func loadData(){
        gameVM.loadAllGameData {
            //展示全部游戏
            self.collectionView.reloadData()
            
            //展示常用游戏(10个)
            self.gameView.groups = Array(self.gameVM.games[0..<10])
            
        }
    }
}

// MARK: 遵守 UICollectionViewDataSource
extension GameVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameVM.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        cell.baseGame = gameVM.games[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.titleL.text = "全部"
        headerView.iconImgV.image = UIImage(systemName: "poweron")?.withTintColor(.red).withRenderingMode(.alwaysOriginal)
        headerView.moreBtn.isHidden = true
        return headerView
    }
    
}
