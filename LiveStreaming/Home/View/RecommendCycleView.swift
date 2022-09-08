//
//  RecommendCycleView.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/2.
//
/*
    首页VC 的推荐界面 -> 无限轮播界面
 */

import UIKit

private let kCycleCellID = "kCycleCellID"

class RecommendCycleView: UIView {

    var cycleTimer: Timer?
    var cycleModels:  [CycleModel]?{
        didSet{
            collectionView.reloadData()
            
            //设置pageControl 个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            //默认滚动到中间某个位置
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    //该方法表示控件刚从xib加载出来
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置该控件不随父控件的拉伸而拉伸
        autoresizingMask = []
        
        //注册cell
        collectionView.register(UINib(nibName: "RecommendCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //通过super.layoutSubviews() 获取到正确的 collectionView.bounds.size,每个cell宽度等于一页宽度
        layout.itemSize = collectionView.bounds.size
    }

}


extension RecommendCycleView {
    // MARK: 提供一个快速创建View的方法
    class func recommendCycleView() -> RecommendCycleView{
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}

// MARK: 遵守 UICollectionViewDataSource
extension RecommendCycleView: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! RecommendCycleCell
        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]
        return cell
    }
}

// MARK: 遵守 UICollectionViewDelegate
extension RecommendCycleView: UICollectionViewDelegate{
    
    // MARK: 监听轮播界面的滑动，pageControl完成跳转
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取滚动的偏移量，在滚动结束前 pageControl完成跳转，需加上scrollView.bounds.width * 0.5
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        //计算pageControl 的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    // MARK: 手动拖动轮播界面时，停止自动轮播
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    // MARK: 手动停止拖动轮播界面时，开始自动轮播
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
    
}


extension RecommendCycleView {
    
    // MARK: 无限轮播界面增加定时器，自动轮播
    private func addCycleTimer(){
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: .common)
    }
    
    private func removeCycleTimer(){
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
    
    @objc private func scrollToNext(){
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        //滚动到该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
