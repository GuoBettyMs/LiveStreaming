//
//  Extensions.swift
//  LiveStreaming
//
//  Created by isdt on 2022/9/29.
//
/*
    扩展
 */

import UIKit

// MARK: -
extension UIBarButtonItem{
    
    /* 类方法
    class func createItem(imgName: UIImage, highImgName: UIImage, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(imgName, for: .normal)
        btn.setImage(highImgName, for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
     */
    
    // MARK: 便利构造函数,必须明确调用一个设计的构造函数
    convenience init(imgName: UIImage, highImgName: UIImage! = nil, size: CGSize = CGSize.zero){
        let btn = UIButton()
        btn.setImage(imgName, for: .normal)
        if highImgName != nil {
            //.withTintColor(.red).withRenderingMode(.alwaysOriginal)  保持原始图片的红色色调
            btn.setImage(highImgName.withTintColor(.red).withRenderingMode(.alwaysOriginal), for: .highlighted)
        }
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)
    }
    
}
// MARK: -
extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor{
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}

// MARK: -
extension NSDate{
    class func getCurrntTime() -> String {
        /* 获取当前时间戳*/
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}

    // MARK: -
extension UIDevice {
    
    /// 顶部安全区高度
    static func xp_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    
    /// 底部安全区高度
    static func xp_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    
    /// 顶部状态栏高度（包括安全区）
    static func xp_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    /// 导航栏高度
    static func xp_navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    /// 状态栏+导航栏的高度
    static func xp_navigationFullHeight() -> CGFloat {
        return UIDevice.xp_statusBarHeight() + UIDevice.xp_navigationBarHeight()
    }
    
    /// 底部导航栏高度
    static func xp_tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    /// 底部导航栏高度（包括安全区）
    static func xp_tabBarFullHeight() -> CGFloat {
        return UIDevice.xp_tabBarHeight() + UIDevice.xp_safeDistanceBottom()
    }
}
