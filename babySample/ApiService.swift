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
    func avaImgupload(image:UIImage) {
        
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
                            //dispatch_async(dispatch_get_main_queue(), {
                            Shared.imageCache.removeAll()
                            //})
                            
                            
                            
                            
                            // 更新 user 頁面
                            NSNotificationCenter.defaultCenter().postNotificationName("reload&CacheUpdate", object: nil)
                            
                        case .Failure(let error):
                            print(error.localizedDescription)
                            
                        }
                    }
                    
                case.Failure(let error):
                    print(error)
                }
        }
    }
    
    // post photo upload
    func postPhotoUpload (post_id:String, image:UIImage){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{ return }
        let image : NSData = UIImageJPEGRepresentation(image, 0.5)!
        let uuid = NSUUID().UUIDString
        let parameterTemp = [
            "pic": NetData(data: image, mimeType: .ImageJpeg, filename: "\(uuid).jpg"),
            "post_id": post_id,
            "token" : AccessToken
        ]
        
        // 新增 api/post/upload  parameter: token , post_id
        let urlRequest = urlRequestWithComponents(
            "http://140.136.155.143/api/post/upload",
            parameters: parameterTemp)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                
            }
            .responseJSON { response in
                
                switch response.result{
                    
                case.Success(let json):
                    print(json)
                case .Failure(let error):
                    print(error)
                }
        }
        
    }
    
    // Get facebook photo path
    func getFBphotos() -> SwiftyJSON.JSON {
        
        var json: SwiftyJSON.JSON!
        
        let graphRequest  = FBSDKGraphRequest(graphPath: "me" as String, parameters: ["fields":"photos{images}"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print(error)
                return
            }
            else
            {
                json = SwiftyJSON.JSON(result)
                print(json)
            }
        })
        
        return json
    }
    
    // Get userID
    func id_request(completion : (String) -> ()){
        
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.GET, "http://140.136.155.143/api/user/token/\(AccessToken!)").validate().responseJSON{ (response) in
            
            switch response.result{
            case .Success(let json):
                let json = SwiftyJSON.JSON(json)
                
                if let id = json["data"][0][JSON_ID].string{
                    
                    // 存取 user id 以供未來使用
                    NSUserDefaults.standardUserDefaults().setObject(id, forKey:USER_ID)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // complete handerler
                    completion(id)
                }
                
                
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Baby Function
    /*
     http://140.136.155.143/api/baby/store
     http://140.136.155.143/api/baby/upload
     http://140.136.155.143/api/baby/search
     http://140.136.155.143/api/baby/searchbyid
     http://140.136.155.143/api/baby/delete
     */
    
    func baby_create( name:String , birth:String, blood:String, babyImg:UIImage ,completion : (SwiftyJSON.JSON)-> ()){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/baby/store",parameters: ["token":AccessToken,"name":name,"birth":birth,"blood":blood]).responseJSON { (response) in
            switch response.result{
                
            case .Success( let json):
                
                let json = SwiftyJSON.JSON(json)
                
                print(json)
                
                guard let babyID = json["_id"].string else { return}
                
                ApiService.shareInstance.baby_ImgUpload(babyID, image: babyImg){ json in
                    print(json)
                }
            case .Failure(let error):
                print( error.localizedDescription)
            }
            
        }
    }
    
    
    func baby_ImgUpload(babyID :String ,image:UIImage, completion : (SwiftyJSON.JSON)-> ()){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{ return }
        let image : NSData = UIImageJPEGRepresentation(image, 0.5)!
        let uuid = NSUUID().UUIDString
        let parameterTemp = [
            "pic": NetData(data: image, mimeType: .ImageJpeg, filename: "\(uuid).jpg"),
            "Baby_id": babyID,
            "token" : AccessToken
        ]
        
        // 新增 api/post/upload  parameter: token , post_id
        let urlRequest = urlRequestWithComponents(
            "http://140.136.155.143/api/baby/upload",
            parameters: parameterTemp)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                print("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                
            }
            .responseJSON { response in
                
                switch response.result{
                    
                case.Success(let json):
                    let json = SwiftyJSON.JSON(json)
                    completion(json)
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    func baby_serach(token : String , completion : (SwiftyJSON.JSON)-> ()){
        
        guard let AccessToken = NSUserDefaults.standardUserDefaults().stringForKey(ACCESS_TOKEN) else{ return }
        
        Alamofire.request(.POST, "http://140.136.155.143/api/baby/search",parameters: ["token":AccessToken]).responseJSON { (response) in
            switch response.result{
                
            case .Success( let json):
                
                let json = SwiftyJSON.JSON(json)
                
                completion(json)
                
            case .Failure(let error):
                print( error.localizedDescription)
            }
            
        }
        
        
    }
    
    
    func baby_searchbyid(Baby_id : String , completion : (SwiftyJSON.JSON)-> ()){
        
        Alamofire.request(.POST, "http://140.136.155.143/api/baby/searchbyid",parameters: ["Baby_id":Baby_id]).responseJSON { (response) in
            switch response.result{
                
            case .Success( let json):
                
                let json = SwiftyJSON.JSON(json)
                completion(json)
                
            case .Failure(let error):
                print( error.localizedDescription)
            }
            
        }
        
    }
    
    
    
    func baby_delete(Baby_id : String , completion : (SwiftyJSON.JSON)-> ()){
        
//        Alamofire.request( BabyRouter.Router.baby_delete(Baby_id)).responseJSON {
        
        Alamofire.request(.POST, "\(BabyRouter.Router.baseURLString)/baby/delete",parameters: ["object_id":Baby_id]).responseJSON {
        
            (response) in
            switch response.result{
                
            case .Success( let json):
                
                let json = SwiftyJSON.JSON(json)
                completion(json)
                
            case .Failure(let error):
                print( error.localizedDescription)
            }
            
        }
    }
    
    
    //  MARK: - Self Function
    /*
     http://140.136.155.143/api/post/search  parameter: token
     */
    func getUser_post(completion : (SwiftyJSON.JSON) -> ()){
        guard let AccessToken:String? = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST, "http://140.136.155.143/api/post/search",parameters:["token":AccessToken!]).validate().responseJSON{ (response) in
            switch response.result{
                
            case . Success( let json ):
                
                let json  = SwiftyJSON.JSON(json)
                
                completion(json)
                
            case . Failure( let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    
    //  MARK: - Feed Function
    /*
     http://140.136.155.143/api/like/press_like   parameter: token , post_id
     http://140.136.155.143/api/like/cancel_like  parameter: token,post_id
     */
    
    func press_like (post_id:String , completion : (SwiftyJSON.JSON) -> ()) {
        
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST,"http://140.136.155.143/api/like/press_like",
            parameters: ["token":AccessToken , "post_id": post_id]).validate().responseJSON{ (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    let json = SwiftyJSON.JSON(json)
                    
                    // complete handerler
                    completion(json)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    
    func cancel_like (post_id:String , completion:(SwiftyJSON.JSON) -> ()){
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST,"http://140.136.155.143/api/like/cancel_like",
            parameters: ["token":AccessToken , "post_id": post_id]).validate().responseJSON{ (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    let json = SwiftyJSON.JSON(json)
                    completion(json)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    
    //  MARK: - Comment API
    /*
     http://140.136.155.143/api/comment/comment       parameter: token , post_id , content
     http://140.136.155.143/api/comment/delete        parameter: token , comment_id
     */
    
    // 新增回覆
    func comment_post (post_id:String ,content:String, completion:(SwiftyJSON.JSON) -> ()){
        
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST,"http://140.136.155.143/api/comment/comment",
            parameters: ["token":AccessToken , "post_id": post_id, "content":content]).validate().responseJSON{ (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    let json = SwiftyJSON.JSON(json)
                    completion(json)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 刪除回覆
    func comment_delete (comment_id:String , completion:(SwiftyJSON.JSON) -> ()){
        
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST,"http://140.136.155.143/api/comment/delete",
            parameters: ["token":AccessToken , "comment_id": comment_id]).validate().responseJSON{ (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    let json = SwiftyJSON.JSON(json)
                    completion(json)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    
    //  MARK: - PDF  API
    /*
     http://140.136.155.143/api/album/html2pdf       parameter: token , album_name , baby_name , url1 , url2, url3, url4, url5, url6 , url7 , url8
     http://140.136.155.143/api/album/search       parameter: token ,
     */
    
    func pdf_create (album_name:String, baby_name:String , url1:String, url2:String,url3:String,url4:String,url5:String,url6:String,url7:String,url8:String,  completion:(SwiftyJSON.JSON) -> ()){
        
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        print(url1)
        print(url2)
        print(url3)
        print(url4)
        print(url5)
        print(url6)
        print(url7)
        print(url8)
        
        
        Alamofire.request(.POST,"http://140.136.155.143/api/album/html2pdf",
            parameters: ["token":AccessToken , "album_name": album_name , "baby_name":baby_name ,"url1":url1 , "url2":url2, "url3":url3, "url4":url4,"url5":url5,"url6":url6,"url7":url7 ,"url8":url8]).validate().responseJSON{ (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    
                    let json = SwiftyJSON.JSON(json)
                    
                    completion(json)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func pdf_search ( completion:(SwiftyJSON.JSON) -> ()){
        
        guard let AccessToken:String = NSUserDefaults.standardUserDefaults().stringForKey("AccessToken") else {return}
        
        Alamofire.request(.POST,"http://140.136.155.143/api/album/search",
            parameters: ["token":AccessToken ]).validate().responseJSON{ (response) in
                
                switch response.result{
                    
                case .Success(let json):
                    
                    let json = SwiftyJSON.JSON(json)
                    
                    completion(json)
                    
                case .Failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    
    /*
     Medicine
     
     http://data.ntpc.gov.tw/od/data/api/E99C3A9A-11E3-423A-9078-C60403371B38?$format=json
     */
    
    func getMedicine (complection :(SwiftyJSON.JSON)->()){
        
        Alamofire.request(.GET , "http://data.ntpc.gov.tw/od/data/api/E99C3A9A-11E3-423A-9078-C60403371B38?$format=json").responseJSON { (response) in
            
            switch response.result{
                
            case .Success( let json):
                
                let json = SwiftyJSON.JSON(json)
                
                complection(json)
                
                
            case .Failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    // MARK: - GuestVC function
    /*
     http://140.136.155.143/api/connection/search_following_byid
     http://140.136.155.143/api/connection/search_followers_byid
     */

    func getGuestFollowings(user_id :String,complection :(SwiftyJSON.JSON)->()){
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_following_byid",parameters: ["user_id":user_id]).responseJSON { (response) in
            
            switch response.result{
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
                
                
                complection(json)
                
            case .Failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    func getGuestFollowers(user_id :String,complection :(SwiftyJSON.JSON)->()){
        
        Alamofire.request(.POST, "http://140.136.155.143/api/connection/search_followers_byid",parameters: ["user_id":user_id]).responseJSON { (response) in
            
            switch response.result{
            case .Success(let json):
                
                let json = SwiftyJSON.JSON(json)
                
                
                complection(json)
                
            case .Failure(let error):
                print(error.localizedDescription)
                
            }
        }

    }

    
    
    
    
    /*
     func myFunction(cityName:String, completion : (JSON) -> ()) {
     Alamofire.request(.POST, "url", parameters: ["city" : cityName], encoding: ParameterEncoding.JSON, headers: ["Authorization": "token"])
     .validate()
     .responseJSON { response in
     switch response.result {
     case .Success:
     let jsonData = JSON(data: response.data!)
     completion(jsonData)
     case .Failure(let error):
     MExceptionManager.handleNetworkErrors(error)
     completion(JSON(data: NSData()))
     }
     }
     }
     
     // Call function
     myFunction("bodrum") { response in
     print(response["yourParameter"].stringValue)
     }
     
     */
    
    // MARK: - HomeVC function
    /*
     http://140.136.155.143/api/baby/store
     http://140.136.155.143/api/baby/search
     http://140.136.155.143/api/baby/searchbyid
     http://140.136.155.143/api/baby/upload
     http://140.136.155.143/api/baby/delete
     */
    
    
    // MARK: - PHOTO FORMAT function
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