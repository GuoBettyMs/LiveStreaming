//
//  RoomNormalVC.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/7.
//
/*
    电脑直播的主播房间
 
 */
import UIKit

class RoomNormalVC: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        
//        //依然保持系统自带的左滑退出手势
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //退出房间后，显示导航栏
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}
