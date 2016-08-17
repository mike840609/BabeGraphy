//
//  Network.swift
//  babySample
//
//  Created by 蔡鈞 on 2016/7/22.
//  Copyright © 2016年 蔡鈞. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import PMAlertController
import Haneke


class ApiService: NSObject {
    
    static let shareInstance = ApiService()
    
    
    
    // 相片上傳
    func avaImgupload(image:UIImage)   {
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{ return }
        
        let image : NSData = UIImageJPEGRepresentation(image, 0.5)!
        
        let uuid = NSUUID().UUIDString
        
        let parameterTemp = [
            "pic" : NetData(data: image, mimeType: .ImageJpeg, filename: "\(uuid).jpg"),
            "token" : AccessToken
        ]
        
        let urlRequest = urlRequestWithComponents(
            "http://140.136.155.143/api/user/upload",
            parameters: parameterTemp)
        
        
        // Url & NSData
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { response in
                
                switch response.result{
                    
                case.Success:
                    
                    // 重設定用戶資訊
                    Alamofire.request(.GET, "http://140.136.155.143/api/user/token/\(AccessToken)").validate().responseJSON{ (response) in
                        
                        switch response.result{
                            
                        case .Success(let json):
                            
                            let json = SwiftyJSON.JSON(json)
                            
                            // 更新用戶資料
                            user = json
                            
                            // 清除圖片快取
                            Shared.imageCache.removeAll()

                            // 更新 user 頁面
                            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                            
                            
                            
                        case .Failure(let error):
                            print(error.localizedDescription)
                            
                        }
                    }
                    
                    
                case.Failure(let error):
                    print(error)
                    
                }
        }
        
    }
    
    

    
    
    
    
    // helper
    // PHOTO FORMAT function
    func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData) {
        
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        
        
        let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add parameters
        for (key, value) in parameters {
            
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            if value is NetData {
                
                // add image
                let postData = value as! NetData
                
                // append content disposition
                let filenameClause = " filename=\"\(postData.filename)\""
                let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
                let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentDispositionData!)
                
                
                // append content type
                //uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!) // mark this.
                let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
                let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
                uploadData.appendData(contentTypeData!)
                uploadData.appendData(postData.data)
                
            }else{
                uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
        }
        
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
}