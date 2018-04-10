//
//  WittyFeedSDKNetworking.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WittyFeedSDKNetworking{
    
    let isCredentialsVerified = false
    let api_client: WittyFeedSDKApiClient!
    let base_url = "https://api.wittyfeed.com"
    
    
    init(api_client: WittyFeedSDKApiClient){
        self.api_client = api_client
    }
    
    
    func getStoryFeedData(isLoadedMore: Bool, loadmore_offset: Int, isBackgroundCacheRefresh: Bool, callback: @escaping (String, Bool, Bool) -> Void) {
        hitApiToVerifyCredentials_and_FetchData(isLoadedMore: isLoadedMore, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: isBackgroundCacheRefresh, callback: callback)
    }
    

    func hitApiToVerifyCredentials_and_FetchData(isLoadedMore: Bool, loadmore_offset: Int, isBackgroundCacheRefresh: Bool, callback: @escaping (String, Bool, Bool) -> Void) {
        
        let feed_url_api = base_url + "/Sdk/home_feed_v4"
        var param: [String:String] = [
            "app_id": api_client.app_id!,
            "api_key": api_client.api_key!,
            "unique_identifier": api_client.package_name!,
            "offset": String(loadmore_offset),
            "client_meta": api_client.user_meta,
        ]
        
        param["firebase_token"] = api_client.fcm_token!
        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token") != nil {
            param["old_firebase_token"] = WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token")
        }
        
        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token") != nil {
            if(api_client.fcm_token != ""){
                if(api_client.fcm_token == WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token")){
                    param["firebase_token"] = ""
                    param["old_firebase_token"] = ""
                }
            }
        }
        
        if ConnectionCheck.isConnectedToNetwork() {
            Alamofire.request(feed_url_api, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let response_json = JSON(responseObject.result.value!)
                        if(response_json["status"].boolValue == true) {
                            WittyFeedSDKSingleton.instance.isDataUpdated = false
                            
                            if (self.api_client.fcm_token != "") {
                                WittyFeedSDKSingleton.instance.witty_deafult.set(self.api_client.fcm_token!, forKey: "wf_saved_fcm_token");
                            }
                            
                            callback(JSON(responseObject.result.value!).rawString()! , isLoadedMore, isBackgroundCacheRefresh)
                        } else {
                            callback("failed", isLoadedMore, isBackgroundCacheRefresh)
                        }
                    } else {
                        callback("failed", isLoadedMore, isBackgroundCacheRefresh)
                    }
            }
        }
        else{
            print("internet connection inactive")
            callback("failed", isLoadedMore, isBackgroundCacheRefresh)
        }
    }
    

    func updateFcmToken(new_fcm_token: String, callback: @escaping (String) -> Void){
        
        let api_url = base_url + "/Sdk/updateToken"
        var param: [String:String] = [
            "app_id": api_client.app_id!,
            "api_key": api_client.api_key!,
            "unique_identifier": api_client.package_name!,
            "client_meta": api_client.user_meta,
        ]
        
        param["firebase_token"] = new_fcm_token
        param["old_firebase_token"] = ""
        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token") != nil {
            param["old_firebase_token"] = WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token")
        }
        
        if ConnectionCheck.isConnectedToNetwork() {
            Alamofire.request(api_url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let response_json = JSON(responseObject.result.value!)
                        if(response_json["status"].boolValue == true) {
                            print("Force Updated FCM Token")
                            WittyFeedSDKSingleton.instance.witty_deafult.set(new_fcm_token, forKey: "wf_saved_fcm_token");
                        } else {
                            callback("failed")
                        }
                    } else {
                        callback("failed")
                    }
            }
        }
        else{
            print("disconnected")
            callback("failed")
        }
        
    }
    
    
    func get_search_results(input_str: String, loadmore_offset: Int, callback: @escaping (String, Bool, Bool) -> Void){
        
        print("search string: \(input_str)")
        
        var api_url = base_url + "/Sdk/search"
        
        api_url += "?"
        api_url += "&keyword=" + input_str
        api_url += "&offset=" + "\(loadmore_offset*10)"
        api_url += "&user_id=" + WittyFeedSDKSingleton.instance.user_id
        api_url += "&app_id=" + api_client.app_id!
    
        
        if ConnectionCheck.isConnectedToNetwork() {
            Alamofire.request(api_url, method: .get, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let response_json = JSON(responseObject.result.value!)
                        if(response_json["status"].boolValue == true) {
                            var isLoadedMore = false;
                            if(loadmore_offset > 0) {
                                isLoadedMore = true;
                            }
                            print("search successful: \(input_str)")
                            callback(JSON(responseObject.result.value!).rawString()!, isLoadedMore, false);
                        } else {
                            callback("failed", false, false)
                        }
                    } else {
                        callback("failed", false, false)
                    }
            }
        }
        else{
            print("disconnected")
            callback("failed", false, false)
        }
        
    }

    
    func fetch_interests(callback: @escaping (String, Bool, Bool) -> Void){
        
        var api_url = base_url + "/Sdk/getCategories"
        
        api_url += "?"
        api_url += "&app_id=" + api_client.app_id!
        api_url += "&device_id=" + api_client.device_id
        
        if ConnectionCheck.isConnectedToNetwork() {
            Alamofire.request(api_url, method: .get, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let response_json = JSON(responseObject.result.value!)
                        if(response_json["status"].boolValue == true) {
                            callback(JSON(responseObject.result.value!).rawString()!, false, false);
                        } else {
                            callback("failed", false, false)
                        }
                    } else {
                        callback("failed", false, false)
                    }
            }
        }
        else{
            print("disconnected")
            callback("failed", false, false)
        }
    }
    
    
    func set_interests(callback: @escaping (String, Bool, Bool) -> Void, interest_id: String, isSelected: Bool){
        
        let api_url = base_url + "/Sdk/saveUserInterest"
        var param: [String:String] = [
            "app_id": api_client.app_id!,
            "selected_cat_id": interest_id,
            "client_meta": api_client.user_meta,
            "device_id": api_client.device_id,
            ]
        
        print("device id: \(api_client.device_id)")
        
        var is_cat_active = 0
        if(isSelected){
            is_cat_active = 1
        }
        param["is_selected"] = "\(is_cat_active)"
        
        if ConnectionCheck.isConnectedToNetwork() {
            Alamofire.request(api_url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let response_json = JSON(responseObject.result.value!)
                        if(response_json["status"].boolValue == true) {
                            callback("success", false, false);
                        } else {
                            callback("failed", false, false)
                        }
                    } else {
                        callback("failed", false, false)
                    }
            }
        }
        else{
            print("disconnected")
            callback("failed", false, false)
        }
    }

    
}
