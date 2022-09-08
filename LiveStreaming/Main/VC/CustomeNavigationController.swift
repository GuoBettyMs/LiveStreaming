//
//  CustomeNavigationController.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/7.
//
/*
    实现全局Pop手势(自定义)
 */

import UIKit

class CustomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //获取系统的Pop手势
        guard let systemGes = interactivePopGestureRecognizer else {return }
        
        //获取手势添加到view中
        guard let gesView = systemGes.view else {return }
        
        //获取target/ action
        //利用运行机制查看所有的属性名称
        /*
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizerDelegate.self, &count!)
        for i in 0..<count{
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString: name))
        }
         */
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else {return }
        print(targetObjc)
        
        //取出target
        guard let target = targetObjc.value(forKey: "target") else {return }
        
        //取出action
        let action = Selector(("handleNavigationTransition:"))
        
        //创建自己的手势
        let panGes = UIPanGestureRecognizer()
        gesView.addGestureRecognizer(panGes)
        panGes.addTarget(target, action: action)

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //隐藏push的控制器的tabbar
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: animated)
    }


}
