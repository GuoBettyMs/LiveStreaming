//
//  PageContentView.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/23.
//
/*
    首页 HomeVC 标题栏对应的 contentView
    PageTitleView发生点击，告知PageContentView 跳转到正确的控制器 -> 通过 setCurrentIndex(currentIndex: Int) 实现
    设置 PageContentViewDelegate 协议，返回 PageContentView 滑动信息(progress、sourceIndex、targetIndex)
 
 */

import UIKit

// MARK: 定义协议
protocol PageContentViewDelegate: class{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

let contentCellID = "contentCellID"

class PageContentView: UIView {
    
    private var childVCs: [UIViewController]
    private weak var parentVC: UIViewController?
    private var startOffsetX: CGFloat = 0
    private var isForbidScrollDelegate: Bool = false
    weak var pageContentViewDelegate: PageContentViewDelegate?
    
    private lazy var collectionView: UICollectionView = { [weak self] in
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        
        return collectionView
    }()    
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?){
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageContentView{
    // MARK: 设置UI界面
    private func setUI(){
        //将所有的子控制器添加到父控制器中
        for childVC in childVCs{
            parentVC?.addChild(childVC)
        }
        
        //collectionView 用于在cell中存放子控制器View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK: 遵守 UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVC = childVCs[indexPath.item]
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
 
}

// MARK: 遵守 UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate{
    
    //开始滑动时的x位置
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //当前执行滑动代理方法, 不执行点击事件
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    //正在滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //判断是否是点击事件
        if isForbidScrollDelegate {return}
        
        var progress: CGFloat = 0           //滑动距离
        var sourceIndex: Int = 0            //初始索引
        var targetIndex: Int = 0            //目标索引

        let currentOffsetX = scrollView.contentOffset.x          //scrollView的当前 x位置
        let scrollViewW = scrollView.bounds.width
        
        /*  ⭕️计算 progress
         手势向左滑，当前的x距离要比开始的x距离大； 手势向右滑，当前的x距离要比开始的x距离小
         1.左滑一个View时，progress = offsetX / width - 1；左滑两个View时，progress = offsetX / width - 2
           令 radio = offsetX / width， 则progress = radio - floor(radio)，floor函数为取整函数
         2.手势左右滑的实际移动距离都是 offsetX / width - 1，但因为手势向右滑，当前的x距离要比开始的x距离小
         所以右滑一个View时，progress = 1 - (offsetX / width - 1)；
         右滑两个View时，progress = 2 - (offsetX / width - 2)
         令 radio = offsetX / width， 则progress = 1 - （radio - floor(radio)），floor函数为取整函数
            
            ⭕️计算 sourceIndex
          手势向左滑，sourceIndex = 当前 x位置 / 屏幕宽度
          手势向右滑，sourceIndex = targetIndex + 1    初始索引=目标索引+1

            ⭕️计算 targetIndex
         手势向左滑，targetIndex = sourceIndex + 1     目标索引=初始索引+1
         手势向右滑，targetIndex = 当前 x位置 / 屏幕宽度
         */

        if currentOffsetX > startOffsetX{
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count{
                targetIndex = childVCs.count - 1
            }
            
            //如果一个view完整左划过去，将旧的targetIndex作为新的sourceIndex
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count{
                sourceIndex = childVCs.count - 1
            }
        }
        
        //将progress、sourceIndex、targetIndex 传递给 titleView
        pageContentViewDelegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK: 对外暴露的方法
extension PageContentView {
    //根据获取到的标题索引，PageContentView 跳转到正确的控制器
    func setCurrentIndex(currentIndex: Int){
        //禁止执行滑动代理方法,当前执行点击事件
        isForbidScrollDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
