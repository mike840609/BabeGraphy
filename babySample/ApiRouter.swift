//
//  ApiRoutine.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/10/3.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire



struct BabyRouter{

    enum  Router: URLRequestConvertible {
        static let baseURLString = "http://140.136.155.143/api"
        
        case baby_delete(String)



        var URLRequest: NSMutableURLRequest {
            
            let result: (path: String, parameters: [String: AnyObject]) = {
                
                switch  self {
                    
                case .baby_delete(let baby_id):
                    let params = ["object_id": baby_id]
                    
                    return ( "/baby/delete"  ,params )
                    
                }
                
            }()
            
            
            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
        
    }
}