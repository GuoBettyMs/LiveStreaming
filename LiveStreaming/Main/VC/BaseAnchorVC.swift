//
//  BaseAnchorVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//
/*
    首页VC 的 通用视图控制器
   
 */

import UIKit

private let kItemMargin: CGFloat = 10                               //推荐界面的item边距
private let kItemW = (kScreenW - 3 * kItemMargin) / 2               //推荐界面的item宽度
private let kNormalItemH = kItemW * 3 / 4                           //推荐界面的一般item高度
private let kHeaderViewH: CGFloat = 50                              //推荐界面的头部View高度

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"


class BaseAnchorVC: UIViewController {

    // MARK: 定义属性
    var baseVM: BaseViewModel!
    
    // MARK: 懒加载
    lazy var collectionV: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadDate()
    }
}


extension BaseAnchorVC{
    // MARK: 设置UI界面
    @objc func setUI(){
        view.addSubview(collectionV)
    }
}

extension BaseAnchorVC{
    @objc func loadDate(){

    }
}

// MARK: 遵守 UICollectionViewDataSource\UICollectionViewDelegate
extension BaseAnchorVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionViewCell
        cell.anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        //取出模型
        headerView.group = baseVM.anchorGroups[indexPath.section]
        return headerView
    }

}
