//
//  NetworkTools.swift
//  LiveStreaming
//
//  Created by gbt on 2022/9/1.
//
/*
    对 Alamofire 进行封装
 */

import UIKit
import Alamofire


enum MethodType{
    case GET
    case POST
}


class NetworkTools: NSObject {

    /*
     //Alamofire 4.0 以上
     class func requestData(type: MethodType, URLString: String, parameters: [String: String]? = nil, finishedCallback: @escaping (_ result: AnyObject) -> ()){

         //发送网络请求
         AF.request(URLString, parameters:parameters).responseJSON { response in
             Logger.debug("NetworkTools response: \(response)")
             
             //获取结果
             guard let result = response.value else{
                 Logger.debug("response.result.error: \(response.error)")
                 return
             }

             finishedCallback(result as AnyObject)  //将结果回馈出去
         }
         
     }
     
     */
    
    
    //Alamofire 4.0
    class func requestData(type: MethodType, URLString: String, parameters: [String: String]? = nil, finishedCallback: @escaping (_ result: AnyObject) -> ()){
        
        //获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        //发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { response in
           //获取结果
            guard let result = response.result.value else{
                print(response.result.error)
                return
            }
            finishedCallback(result as AnyObject)       //将结果回馈出去
        }
    }

    /* info 文件需要添加 App Transport Security Settings -> Allow Arbitrary Loads，改为YES
    
     Alamofire.request("http://httpbin.org/get", method: .get).responseJSON { (response) in
        guard let result = response.result.value else{
            print(response.result.error)
            return
        }
        print(result)
    }
     
     
     Alamofire.request("http://httpbin.org/get", parameters: ["name": "why"]).responseJSON { response in
         
         guard let result = response.result.value else{
             print(response.result.error)
             return
         }
         print(result)
     }
     
     */

    
}
