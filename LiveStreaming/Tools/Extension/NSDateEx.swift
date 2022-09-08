//
//  NSDateEx.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/1.
//

import Foundation

extension NSDate{
    class func getCurrntTime() -> String {
        /* 获取当前时间戳*/
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
