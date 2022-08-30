//
//  HomeVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/19.
//
/*
    首页 HomeVC
 1. 导航栏
 2. PageTitleView 标题栏 (4个)： 推荐、游戏、娱乐、趣玩
    -> 根据PageTitleViewDelegate 协议，获取到点击的标题索引，将标题索引发送给setCurrentIndex(currentIndex: Int)， PageContentView 跳转到正确的控制器
 3. PageContentView 标题栏对应的内容 (4个)
    -> 
     (1) 推荐界面  collectionView
          a. 无限轮播界面
          b. 游戏Icon界面
          c. 主播房间界面
     (2) 游戏界面  collectionView
          a. 常用游戏Icon界面 （10个）
          b. 全部游戏Icon界面
     (3) 娱乐界面  collectionView
          a. 界面
          b. 界面
          c. 界面
     (4) 趣玩界面  collectionView
          a. 主播房间界面

 
 */

import UIKit


private let kTitleViewH: CGFloat = 40                   // HomeVC 的标题栏高度

class HomeVC: UIViewController {

    // MARK: PageTitleView 标题栏懒加载属性
    private lazy var pageTitleView: PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.pageTitleViewDelegate = self
        return titleView
    }()
    
    // MARK: PageContentView 懒加载属性
    private lazy var pageContentView: PageContentView = {  [weak self] in
        let contenVFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH)

        var childVCs = [UIViewController]()
        childVCs.append(RecommendVC())
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = .randomColor()
            childVCs.append(vc)
        }
        let contentView = PageContentView(frame: contenVFrame, childVCs: childVCs, parentVC: self)
        contentView.pageContentViewDelegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

}


extension HomeVC{
    // MARK: 设置UI界面
    private func setUI(){
        setNavigationBar()
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
    
    // MARK: 设置导航条
    private func setNavigationBar(){
        //设置左侧Bar Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imgName: UIImage(named: "logo")!)

        //设置右边 Item
        let  size = CGSize(width: 40, height: 40)
        let histortItem = UIBarButtonItem(imgName: UIImage(systemName: "clock")!, highImgName: UIImage(systemName: "clock")!, size: size)
        let searchItem = UIBarButtonItem(imgName: UIImage(systemName: "magnifyingglass")!, highImgName: UIImage(systemName: "magnifyingglass")!, size: size)
        let qccodeItem = UIBarButtonItem(imgName: UIImage(systemName: "viewfinder")!, highImgName: UIImage(systemName: "viewfinder")!, size: size)
        navigationItem.rightBarButtonItems = [histortItem, searchItem, qccodeItem]
    }
}

// MARK: 遵守 PageTitleView 代理
extension HomeVC: PageTitleViewDelegate{
    //pageContentView 获取到点击的标题索引
    func pageTitleView(titleView titileView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

// MARK: 遵守 PageContentViewDelegate 代理
extension HomeVC: PageContentViewDelegate{
    //pageTitleView 获取到滑动信息(progress、sourceIndex、targetIndex)
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
