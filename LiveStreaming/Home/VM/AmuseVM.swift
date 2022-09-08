//
//  AmuseVM.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//
/*
    首页VC 的娱乐界面的网络请求
 */

import UIKit

class AmuseVM: BaseViewModel {
   
}

extension AmuseVM {
    func loadAmuseData(finishCallback: @escaping () -> ()){
        laodAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishCallback: finishCallback)
    }
}
