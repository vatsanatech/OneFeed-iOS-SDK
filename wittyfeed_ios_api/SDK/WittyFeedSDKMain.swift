//
//  WittyFeedSDKMain.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import SwiftyJSON

class WittyFeedSDKMain {
    
    let mainControllerContext: UIViewController!
    let wittyFeedSdkNetworking: WittyFeedSDKNetworking
    let wittyFeedSDKApiClient: WittyFeedSDKApiClient!
    
    let witty_user_deafults = UserDefaults.standard
    
    var sdk_main_init_callback: (String) -> Void = {_ in }
    var sdk_main_did_feed_prepared_callback: (String) -> Void = {_ in }
    
    var fetch_more_init_main_callback: (String) -> Void = {_ in }
    
    let requestType = "waterfall";
    
    init(vc: UIViewController, wittyFeedSDKApiClient: WittyFeedSDKApiClient){
        self.mainControllerContext = vc
        self.wittyFeedSDKApiClient = wittyFeedSDKApiClient
        WittyFeedSDKSingleton.instance.wittyFeed_sdk_api_client = wittyFeedSDKApiClient
        self.wittyFeedSdkNetworking = WittyFeedSDKNetworking(vc: mainControllerContext!, app_id: wittyFeedSDKApiClient.app_id!, api_key: wittyFeedSDKApiClient.api_key!, package_name: wittyFeedSDKApiClient.package_name!, fcm_token: wittyFeedSDKApiClient.fcm_token!, para_user_meta: wittyFeedSDKApiClient.user_meta)
    }
    
    
    func init_wittyfeed_sdk(){
        WittyFeedSDKSingleton.instance.m_GA = WittyFeedSDKGoogleAnalytics(tracking_id: "UA-40875502-17", client_fcm: wittyFeedSDKApiClient.fcm_token!)
        WittyFeedSDKSingleton.instance.m_GA.send_event_tracking_GA_request(event_category: "WF SDK", event_action: wittyFeedSDKApiClient.app_id, event_value: "1", event_label: "WF SDK initialized") { (status) in
            print(status)
        }
        
        wittyFeedSdkNetworking.verify_credentials { (status) in
            self.sdk_main_init_callback(status)
            
        }
    }
    
    
    func fetch_more_data(fetch_more_main_callback:@escaping (String) -> Void, loadmore_offset: Int){
        
        wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: true, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh, requestType, cat_name, cat_id) in
//            print("fetch_more_data \(jsonStr)")
            
            if(jsonStr != "failed"){
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, requestType: requestType, cat_name: cat_name, cat_id: cat_id)
                print(WittyFeedSDKSingleton.instance.block_arr.count)
                self.fetch_more_init_main_callback = fetch_more_main_callback
                self.fetch_more_init_main_callback("success")
                
                return
                
            }
        }
        
    }
    
    func fetch_more_data(fetch_more_main_callback:@escaping (String) -> Void, loadmore_offset: Int, requestType: String){
        wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: true, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh, requestType, cat_name, cat_id) in
     //       print("fetch_more_data \(jsonStr)")
            if(jsonStr != "failed"){
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, requestType: requestType, cat_name: cat_name, cat_id: cat_id)
                print(WittyFeedSDKSingleton.instance.block_arr.count)
                self.fetch_more_init_main_callback = fetch_more_main_callback
            }
        }
    }
    
    func fetch_more_data(fetch_more_main_callback:@escaping (String) -> Void, loadmore_offset: Int, requestType: String, cat_name: String) {
        wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: true, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh, requestType, cat_name, cat_id) in
             // print("fetch_more_data \(jsonStr)")
            if(jsonStr != "failed"){
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, requestType: requestType, cat_name: cat_name, cat_id: cat_id)
                print(WittyFeedSDKSingleton.instance.block_arr.count)
                self.fetch_more_init_main_callback = fetch_more_main_callback
            }
        }
    }
    
    func refreshFeedData(isBackgroundCacheRefresh : Bool, refresh_data_main_callback:@escaping (String) -> Void, requestType: String, catName: String, catId: String) {
        
        if(requestType == "waterfall" || requestType == ""){
            wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: isBackgroundCacheRefresh, callback: { (jsonStr: String, isLoadedMore: Bool, isBackgroundCacheRefresh: Bool, requestType: String, catName: String, catId: String) in
                
                if(jsonStr != "failed"){
                    self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundCacheRefresh, requestType: requestType, cat_name: catName, cat_id: catId)
                    refresh_data_main_callback("success")
                } else {
                   refresh_data_main_callback("failed")
                }
            })
        }
    }
    
    func handle_feeds_result(jsonStr: String, isLoadedMore: Bool, isBackgroundRefresh: Bool, requestType: String, cat_name: String, cat_id: String){
        let block_json_arr = JSON.init(parseJSON: jsonStr)["data"].arrayValue
        var local_block_arr = [Block]()
        if(requestType == "waterfall"){
            if(!isLoadedMore && !isBackgroundRefresh){
                WittyFeedSDKSingleton.instance.block_arr.removeAll()
            }
            
            if(!isBackgroundRefresh){
                for item in block_json_arr{
                    let block_type = item["type"].stringValue
                    WittyFeedSDKSingleton.instance.card_type = block_type
                    let card_json_arr = item["story"].arrayValue
                    local_block_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
                }
                WittyFeedSDKSingleton.instance.block_arr += local_block_arr
                
                if(!isLoadedMore){
                    WittyFeedSDKSingleton.instance.witty_deafult.set(jsonStr, forKey: "witty_data")
                }
            } else {
                WittyFeedSDKSingleton.instance.witty_deafult.set(jsonStr, forKey: "witty_data")
            }
        }
    }
    
    
    func prepare_feed(){
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "witty_data") != nil   {
            // loading data from cache
            let data = WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "witty_data")!
            handle_feeds_result(jsonStr: data, isLoadedMore: false, isBackgroundRefresh: false, requestType: "waterfall", cat_name: "", cat_id: "")
            
            // and refreshing feed in background
            wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: true) { (jsonStr, isLoadedMore, isBackgroundRefresh, requestType, cat_name, cat_id) in
                if(jsonStr == "failed"){
                    self.sdk_main_did_feed_prepared_callback("failed")
                    return
                }
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, requestType: requestType, cat_name: cat_name, cat_id: cat_id)
                print(WittyFeedSDKSingleton.instance.block_arr.count)
                self.sdk_main_did_feed_prepared_callback("success")
            }
            
        } else {
            // load fresh feed
            wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh, requestType, cat_name, cat_id) in
                if(jsonStr == "failed"){
                    self.sdk_main_did_feed_prepared_callback("failed")
                    return
                }
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, requestType: requestType, cat_name: cat_name, cat_id: cat_id)
                print(WittyFeedSDKSingleton.instance.block_arr.count)
                self.sdk_main_did_feed_prepared_callback("success")
            }
            
        }
    }
    
    
    func set_sdk_init_main_callback( init_callback:@escaping (String) -> Void  ){
        self.sdk_main_init_callback = init_callback
    }
   
    
    func set_sdk_main_did_feed_prepared_callback( feed_callback:@escaping (String) -> Void  ){
        self.sdk_main_did_feed_prepared_callback = feed_callback
    }
    
}
