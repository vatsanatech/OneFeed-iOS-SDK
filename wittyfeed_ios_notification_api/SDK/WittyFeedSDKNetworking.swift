//
//  WittyFeedSDKNetworking.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WittyFeedSDKNetworking{
    
    let app_id, api_key, package_name, fcm_token, user_meta: String!
    let vc_context: UIViewController!
    let isCredentialsVerified = false
    
    
    init(vc: UIViewController, app_id: String, api_key: String, package_name: String, fcm_token: String, para_user_meta: String){
        self.vc_context = vc
        self.app_id = app_id
        self.api_key = api_key
        self.package_name = package_name
        self.fcm_token = fcm_token
        self.user_meta = para_user_meta
    }
    
    
    func verify_credentials(callback: @escaping (String) -> Void) {
        let verify_url_api = "https://api.wittyfeed.com/Sdk/identify";
        let param: [String:String] = [
            "app_id": app_id,
            "api_key": api_key,
            "unique_identifier": Bundle.main.bundleIdentifier! /* "com.sdk.wittyfeed.debug" */ ,
            
            "firebase_token": fcm_token!,
            //
            /* === FIELDS BELOW ARE NOT MANDATORY === */
            //
            "client_id": "",
            "client_name": "",
            "client_email": "",
            "client_meta": user_meta!
        ]
        
        Alamofire.request(verify_url_api, parameters: param, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    callback("success")
                } else {
                    callback("failed")
                }
        }
    }
    
    
    func getStoryFeedData(isLoadedMore: Bool, loadmore_offset: Int, isBackgroundCacheRefresh: Bool, callback: @escaping (String, Bool, Bool, String, String, String) -> Void) {
        hitApiToGetData(isLoadedMore: isLoadedMore, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: isBackgroundCacheRefresh, request_type: "waterfall", cat_name: "", cat_id: "", callback: callback)
    }
    
    
    func getStoryFeedData(isLoadedMore: Bool, loadmore_offset: Int, isBackgroundCacheRefresh: Bool, request_type: String, callback: @escaping (String, Bool, Bool, String, String, String) -> Void) {
        hitApiToGetData(isLoadedMore: isLoadedMore, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: isBackgroundCacheRefresh, request_type: request_type, cat_name: "", cat_id: "", callback: callback)
    }
    
    
    func getStoryFeedData(isLoadedMore: Bool, loadmore_offset: Int, isBackgroundCacheRefresh: Bool, request_type: String, cat_name: String, cat_id: String, callback: @escaping (String, Bool, Bool, String, String, String) -> Void) {
        hitApiToGetData(isLoadedMore: isLoadedMore, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: isBackgroundCacheRefresh, request_type: request_type, cat_name: cat_name, cat_id: cat_id, callback: callback)
    }
    
    
    func hitApiToGetData(isLoadedMore: Bool, loadmore_offset: Int, isBackgroundCacheRefresh: Bool, request_type: String, cat_name: String, cat_id: String, callback: @escaping (String, Bool, Bool, String, String, String) -> Void) {
        
        let feed_url_api = "https://api.wittyfeed.com/Sdk/home_feed_v2";
        let param: [String:String] = [
            "app_id": app_id,
            "api_key": api_key,
            "unique_identifier": Bundle.main.bundleIdentifier! /* "com.sdk.wittyfeed.debug" */ ,
            "offset": String(loadmore_offset),
            "firebase_token": fcm_token,
            "type": request_type,
            "cat_id": cat_id,
            "cat_name": cat_name,
        ]
        
        Alamofire.request(feed_url_api, parameters: param, encoding: URLEncoding.default, headers: nil)
            .responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    callback(JSON(responseObject.result.value!).rawString()! , isLoadedMore, isBackgroundCacheRefresh, request_type, cat_name, cat_id)
                } else {
                    callback("failed", isLoadedMore, isBackgroundCacheRefresh, request_type, cat_name, cat_id)
                }
        }
        
    }
    
    
    
    
    
    
}
