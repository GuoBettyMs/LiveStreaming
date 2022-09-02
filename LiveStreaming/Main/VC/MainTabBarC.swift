//
//  MainTabBarC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/8/19.
//
/*
    TabBar 对应 4个 ViewController
 1. 首页 HomeVC
 2. 直播 LiveVC
 3. 关注 FollowVC
 4. 我的 ProfileVC
 
 */


import UIKit

class MainTabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: 增加故事版ViewController
    private func addChildVC(_ storyName: String){
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        addChild(childVC)
    }


}
