//
//  RecommendGameV.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC 的推荐界面 -> 游戏Icon界面
 */
import UIKit

private let kRecommendGameCellID = "kGameCellID"
private let kEdgeInsetMargin: CGFloat = 10                               //游戏Icon界面的边距

class RecommendGameV: UIView {

    var groups: [BaseGameModel]?{
        didSet{  
            collectionV.reloadData()
        }
    }
    
    @IBOutlet weak var collectionV: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()

        //设置该控件不随父控件的拉伸而拉伸
        autoresizingMask = []
        
        //注册cell
        collectionV.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kRecommendGameCellID)
        
        //给collectionV 添加内边距
        collectionV.contentInset = UIEdgeInsets(top: 0, left: kEdgeInsetMargin, bottom: 0, right: kEdgeInsetMargin)
        
    }

}

extension RecommendGameV {
    // MARK: 提供一个快速创建View的方法
    class func recommendGameV() -> RecommendGameV{
        return Bundle.main.loadNibNamed("RecommendGameV", owner: nil, options: nil)?.first as! RecommendGameV
    }
}

// MARK: 遵守 UICollectionViewDataSource
extension RecommendGameV: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRecommendGameCellID, for: indexPath) as! CollectionGameCell
        cell.baseGame = groups![indexPath.item]
        return cell
    }
    
}
