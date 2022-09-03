//
//  PageTitleView.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/23.
//
/*
    首页 HomeVC 的标题栏
 存放标题的子控件 scrollView
 子控件增加上下边框 topLine、bottomLine
 子控件增加滑块 scrollLine
 
 设置 PageTitleViewDelegate 协议，返回标题的点击回馈
 PageContentView发生滑动，告知 PageTitleView 跳转到正确的标题-> 通过 setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) 实现
 */

import UIKit

// MARK: 定义协议
protocol PageTitleViewDelegate: class{
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

private let kScrollViewBorderH: CGFloat = 0.5                           //标题栏上下边框的高度
private let kScrollViewLineH: CGFloat = 2                               //标题栏滑块高度
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85,85,85)      //标题颜色
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255,128,0)     //标题高亮颜色

class PageTitleView: UIView {

    // MARK: 定义属性
    private var currentIndex: Int = 0
    private var titles: [String]
    weak var pageTitleViewDelegate: PageTitleViewDelegate?
    
    // MARK: 标题栏子控件懒加载属性
    private lazy var titleLabels: [UILabel] = []
    private lazy var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    //标题栏滑块懒加载属性
    private lazy var scrollLine: UIView = {
        let scrollView = UIView()
        scrollView.backgroundColor = .orange
        return scrollView
    }()
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles: [String]){
        self.titles = titles
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageTitleView{
    // MARK: 设置UI 界面
    private func setUI(){
        addSubview(titleScrollView)
        
        //不需要调整UISCrollView的内边距
        titleScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        titleScrollView.frame = bounds
        
        setTitleLabels()
        setBorderAndScrollLine()
    }
    
    // MARK: 增加标题对应的label
    private func setTitleLabels(){
        
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollViewBorderH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated(){
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font  = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center

            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            titleScrollView.addSubview(label)
            titleLabels.append(label)
            
            //给label 添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    // MARK: 设置标题的上下边框 和下框滚动的滑块
    private func setBorderAndScrollLine(){
        //上下边框
        let topLine = UIView()
        topLine.backgroundColor = .lightGray
        topLine.frame = CGRect(x: 0, y: kScrollViewBorderH, width: frame.width, height: kScrollViewBorderH)
        addSubview(topLine)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        bottomLine.frame = CGRect(x: 0, y: frame.height - kScrollViewBorderH, width: frame.width, height: kScrollViewBorderH)
        addSubview(bottomLine)
        
        //添加滑块
        guard let firstLabel = titleLabels.first else { return }        //获取第一个label
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        titleScrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollViewBorderH - kScrollViewLineH, width: firstLabel.frame.width, height: kScrollViewLineH)
    }
}


extension PageTitleView{
    // MARK: 监听标题栏 label的点击
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer){

        //获取当前label
        guard let currentLabel = tapGes.view as? UILabel else{ return }
        
        //如果重复点击同一个title，直接返回
        if currentLabel.tag == currentIndex {return}

        //获取之前的label
        let oldLabel = titleLabels[currentIndex]
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //保存最新label 的下标
        currentIndex = currentLabel.tag
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        pageTitleViewDelegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

// MARK: 对外暴露的方法
extension PageTitleView{
    //根据获取到的滑动信息(progress、sourceIndex、targetIndex)，PageTitleView 跳转到正确的标题
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int){
        let sourceL = titleLabels[sourceIndex]
        let targetL = titleLabels[targetIndex]
        
        //处理滑块的逻辑
        let moveTotalX = targetL.frame.origin.x - sourceL.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceL.frame.origin.x + moveX
        
        //标题颜色由橙色渐变成灰色，灰色渐变成橙色
        //取出变化的范围
        let colorRange = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        sourceL.textColor = UIColor(r: kSelectColor.0 - colorRange.0 * progress, g: kSelectColor.1 - colorRange.1 * progress, b: kSelectColor.2 - colorRange.2 * progress)
        targetL.textColor = UIColor(r: kNormalColor.0 + colorRange.0 * progress, g: kNormalColor.1 + colorRange.1 * progress, b: kNormalColor.2 + colorRange.2 * progress)
        
        //记录新的index
        currentIndex = targetIndex
    }
}
