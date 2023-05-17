//
//  AmuseMenuView.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//

import UIKit

private let kMenuCellID = "kMenuCellID"

class AmuseMenuView: UIView {
    
    // MARK: 数组模型
    var groups: [AnchorGroup]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: 从xib加载出来
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "AmuseMenuViewCell", bundle: nil), forCellWithReuseIdentifier: kMenuCellID)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
    
}


extension AmuseMenuView{
    // MARK: 提供一个快速创建View的方法
    class func amuseMenuView() -> AmuseMenuView{
        return Bundle.main.loadNibNamed("AmuseMenuView", owner: nil, options: nil)?.first as! AmuseMenuView
    }
}


extension AmuseMenuView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if groups == nil {return 0}
        let pageNum = (groups!.count - 1) / 8 + 1
        pageControl.numberOfPages = pageNum
        return pageNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMenuCellID, for: indexPath) as! AmuseMenuViewCell
        
        //给cell设置数据
        setCellDataWithCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func setCellDataWithCell(cell: AmuseMenuViewCell, indexPath: IndexPath){
        //0页： 0～7
        //1页： 8～15
        //2页： 16～23
        //取出起始位置&终点位置
        let startIndex = indexPath.item * 8
        var endIndex = (indexPath.item + 1) * 8 - 1
        
        //判断越界问题
        if endIndex > groups!.count - 1{
            endIndex = groups!.count - 1
        }
        
        //取出数据，并且赋值给cell
        cell.groups = Array(groups![startIndex...endIndex])
    }
    
}


// MARK: 遵守
extension AmuseMenuView: UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}
