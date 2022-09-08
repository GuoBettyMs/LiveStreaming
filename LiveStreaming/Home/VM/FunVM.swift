//
//  FunVM.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/3.
//

import UIKit

class FunVM: BaseViewModel {
    
}

extension FunVM{
    func loadFunData(finishedCallback: @escaping () -> ()){
        laodAnchorData(isGroupData: false ,URLString: "http://capi.douyucdn.cn/api/v1/getColumnRoom/1", parameters: ["limit": "30", "offset": "0"], finishCallback: finishedCallback)
    }
}
