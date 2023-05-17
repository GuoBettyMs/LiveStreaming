//
//  CycleView.swift
//  LiveStreaming
//
//  Created by gbt on 2023/5/17.
//
/*
    首页VC 的推荐界面 -> 无限轮播界面(纯代码)
 */
import UIKit

private let kCycleCellID = "kCycleCellID"

class CycleView: UIView {
    
    var collectionV: UICollectionView!
    let pageControl = UIPageControl()
    
    var cycleTimer: Timer?
    var cycleModels:  [CycleVModel]?{
        didSet{
            collectionV!.reloadData()

            //设置pageControl 个数
            pageControl.numberOfPages = cycleModels?.count ?? 0

            //初始索引路径为[0,0],设置默认从[0,40]开始滚动
//            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 10, section: 0)
//            collectionV!.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(){

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0 //列间距
        layout.minimumLineSpacing = 0 //行间距
        
        collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)//初始化
        collectionV!.translatesAutoresizingMaskIntoConstraints = false
        collectionV!.isPagingEnabled = true //支持手动翻页
        collectionV!.register(CycleVCell.self, forCellWithReuseIdentifier: kCycleCellID)
        collectionV!.dataSource = self
        collectionV!.delegate = self

        addSubview(collectionV!)
        addSubview(pageControl)
        /*
         pod 'SnapKit', '~> 5.6.0'
         collectionV!.snp.makeConstraints { make in
             make.width.equalToSuperview()
             make.height.equalToSuperview()
             make.top.equalToSuperview()
             make.left.equalToSuperview()
         }

         pageControl.snp.makeConstraints { make in
             make.width.equalToSuperview()
             make.height.equalTo(26)
             make.bottom.equalToSuperview()
             make.centerX.equalToSuperview()
         }
         
         */ 
        
        pageControl.tintColor = .systemGray
        pageControl.currentPageIndicatorTintColor = .orange
        pageControl.backgroundColor = UIColor.black.withAlphaComponent(0.5)

    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置collectionView的layout
        let layout = collectionV!.collectionViewLayout as! UICollectionViewFlowLayout
        
        //通过super.layoutSubviews() 获取到正确的 collectionView.bounds.size,每个cell宽度等于一页宽度
        layout.itemSize = collectionV!.bounds.size
    }

}

// MARK: 遵守 UICollectionViewDataSource
extension CycleView: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //为了保证collectionView轮播时一直有cell,设置无限cell
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //cycleModels数组的参数个数应该为cycleModels!.count,如[0,1,2,3],但是由于设置了无限cell,所以最终cycleModels!.count是[0,1,2,...]
        //可令4个cell为一组,用索引路径除以实际数组的参数个数(indexPath.item/4),余下的值([0,1,2,3])就刚好可以对应实际cell的索引

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CycleVCell
        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]
//        Logger.debug("indexPath.item: \(indexPath) -- \(indexPath.item) -- \(indexPath.item % cycleModels!.count)")
        let tapG = UITapGestureRecognizer(target: self, action: #selector(openweb))
        cell.addGestureRecognizer(tapG)
        return cell
    }
    
    // MARK: 链接商城网站
    @objc func openweb(gestureRecognizier: UITapGestureRecognizer){
        
        let row = gestureRecognizier.location(in: self.collectionV)
        guard let indexPath = self.collectionV.indexPathForItem(at: row) else {
            return
        }
        

//        var rootViewController: UINavigationController? = nil
//        let shoppingwebVC = ShoppingwebVC()
//        rootViewController = UINavigationController(rootViewController: shoppingwebVC)
//        rootViewController?.modalPresentationStyle = .fullScreen
//        self.controllerV!.present(rootViewController!, animated: true, completion: nil)
    }
}

// MARK: 遵守 UICollectionViewDelegate
extension CycleView: UICollectionViewDelegate{
    
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

extension CycleView {
    
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
        
        let currentOffsetX = collectionV!.contentOffset.x
        let offsetX = currentOffsetX + collectionV!.bounds.width

        //滚动到该位置
        collectionV!.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
