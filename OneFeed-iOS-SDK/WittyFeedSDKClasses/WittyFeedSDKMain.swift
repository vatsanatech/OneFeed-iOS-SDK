//
//  WittyFeedSDKMain.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import SwiftyJSON

public class WittyFeedSDKMain {
    
    let wittyFeedSdkNetworking: WittyFeedSDKNetworking
    let wittyFeedSDKApiClient: WittyFeedSDKApiClient!
    let witty_user_deafults = UserDefaults.standard
    var sdk_main_init_callback: (String) -> Void = {_ in }
    var fetch_more_init_main_callback: (String) -> Void = {_ in }
    
    
    public init(wittyFeedSDKApiClient: WittyFeedSDKApiClient){
        self.wittyFeedSDKApiClient = wittyFeedSDKApiClient
        WittyFeedSDKSingleton.instance.wittyFeed_sdk_api_client = wittyFeedSDKApiClient
        self.wittyFeedSdkNetworking = WittyFeedSDKNetworking(api_client: wittyFeedSDKApiClient)
        WittyFeedSDKSingleton.instance.wittyFeed_sdk_main = self
        
    }
    
    func fetch_more_data(loadmore_offset : Int, fetch_more_main_callback:@escaping (String) -> Void) {
        wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: false, callback: { (jsonStr: String, isLoadedMore: Bool, isBackgroundCacheRefresh: Bool) in
            if(jsonStr != "failed"){
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: true, isBackgroundRefresh: isBackgroundCacheRefresh, isCached: false)
                fetch_more_main_callback("success")
            } else {
                fetch_more_main_callback("failed")
            }
        })
    }
    
    func fetch_more_NativeCard_data(card_id: String , loadmore_offset : Int, fetch_more_main_callback:@escaping (String) -> Void) {
        wittyFeedSdkNetworking.getStoryNativeCardData(card_id: card_id, isLoadedMore: false, loadmore_offset: loadmore_offset, isBackgroundCacheRefresh: false, callback: { (jsonStr: String, isLoadedMore: Bool, isBackgroundCacheRefresh: Bool, card_id: String) in
            if(jsonStr != "failed"){
                self.handle_nativeCard_feeds_result(card_id: card_id, jsonStr: jsonStr, isLoadedMore: true, isBackgroundRefresh: isBackgroundCacheRefresh, isCached: false)
                
                fetch_more_main_callback("success")
            } else {
                fetch_more_main_callback("failed")
            }
        })
    }
    
    
    func search_content(search_input_str: String, loadmore_offset : Int, search_content_main_callback:@escaping (String) -> Void) {
        
        wittyFeedSdkNetworking.get_search_results(input_str: search_input_str, loadmore_offset: loadmore_offset, callback: { (jsonStr: String, isLoadedMore: Bool, isBackgroundCacheRefresh: Bool) in
            if(jsonStr != "failed"){
                self.handle_search_result(jsonString: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundCacheRefresh, is_cached: false)
                search_content_main_callback("success")
            } else {
                search_content_main_callback("failed")
            }
        })
    }
    //
    //MARK: Private Methods
    //
    func handle_feeds_result(jsonStr: String, isLoadedMore: Bool, isBackgroundRefresh: Bool, isCached: Bool){
        let block_json_arr = JSON.init(parseJSON: jsonStr)["feed_data"]["blocks"].arrayValue
        self.handle_search_block_data_result(jsonString: jsonStr)
        WittyFeedSDKSingleton.instance.user_id = JSON.init(parseJSON: jsonStr)["feed_data"]["config"]["user_id"].string!
        var local_block_arr = [Block]()
        
        if(!isLoadedMore && !isBackgroundRefresh){
            WittyFeedSDKSingleton.instance.block_arr.removeAll()
        }
        
        if(!isBackgroundRefresh){
            for item in block_json_arr{
                let block_type = item["meta"]["type"].stringValue
                let card_json_arr = item["cards"].arrayValue
                local_block_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
            }
            WittyFeedSDKSingleton.instance.block_arr += local_block_arr
            
            if(!isLoadedMore){
                if(!isCached){
                    WittyFeedSDKSingleton.instance.witty_deafult.set(jsonStr, forKey: "witty_data")
                }
            }
        } else {
            WittyFeedSDKSingleton.instance.witty_deafult.set(jsonStr, forKey: "witty_data")
        }
    }
    
    
    func handle_nativeCard_feeds_result(card_id: String, jsonStr: String, isLoadedMore: Bool, isBackgroundRefresh: Bool, isCached: Bool){
        let cardId = JSON.init(parseJSON: jsonStr)["repeating_data"]["meta"]["card_id"].stringValue
        let card_arr = JSON.init(parseJSON: jsonStr)["repeating_data"]["cards"].arrayValue
        let cardModelArray = RepeatingCardModel(card_json_arr: card_arr, card_id: cardId)
        WittyFeedSDKSingleton.instance.dict[cardId] = cardModelArray
       
       

        
//        if(!isLoadedMore && !isBackgroundRefresh){
//            WittyFeedSDKSingleton.instance.block_arr.removeAll()
//        }
        
//        if(!isBackgroundRefresh){
//            for item in block_json_arr{
//                let block_type = item["meta"]["type"].stringValue
//                let card_json_arr = item["cards"].arrayValue
//                local_block_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
//            }
//            WittyFeedSDKSingleton.instance.block_arr += local_block_arr
//
//            if(!isLoadedMore){
//                if(!isCached){
//                    WittyFeedSDKSingleton.instance.witty_deafult.set(jsonStr, forKey: "witty_data")
//                }
//            }
//        } else {
//            WittyFeedSDKSingleton.instance.witty_deafult.set(jsonStr, forKey: "witty_data")
//        }
    }
    
    func handle_search_result(jsonString: String , isLoadedMore: Bool, isBackgroundRefresh: Bool, is_cached: Bool) {
        
        let local_block_json_arr = JSON.init(parseJSON: jsonString)["feed_data"]["blocks"].arrayValue
        if(!isLoadedMore){
            WittyFeedSDKSingleton.instance.search_blocks_arr.removeAll()
        }
        
        var local_block_arr = [Block]()
        
        for item in local_block_json_arr{
            let block_type = item["meta"]["type"].stringValue
            let card_json_arr = item["cards"].arrayValue
            local_block_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
        }
        
        WittyFeedSDKSingleton.instance.search_blocks_arr += local_block_arr
    }
    
    func handle_search_block_data_result(jsonString: String){
        //for search block_data start
        let local_block_data_json_arr = JSON.init(parseJSON: jsonString)["search_data"]["blocks"].arrayValue
        var local_block_data_arr = [Block]()
        // WittyFeedSDKSingleton.instance.search_blocks_data_arr.removeAll()
        
        for item in local_block_data_json_arr{
            let block_type = item["meta"]["type"].stringValue
            let card_json_arr = item["cards"].arrayValue
            local_block_data_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
        }
        
        WittyFeedSDKSingleton.instance.search_blocks_data_arr += local_block_data_arr
        //for serach block_data end
    }
    
    func handle_interests_result(jsonString: String) {
        let local_block_json_arr = JSON.init(parseJSON: jsonString)["feed_data"]["blocks"].arrayValue
        
        var local_block_arr = [Block]()
        WittyFeedSDKSingleton.instance.interests_block_arr.removeAll()
        
        for item in local_block_json_arr{
            let block_type = item["meta"]["type"].stringValue
            let card_json_arr = item["cards"].arrayValue
            local_block_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
        }
        
        WittyFeedSDKSingleton.instance.interests_block_arr += local_block_arr
    }
    
    func prepare_feed(){
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "witty_data") != nil   {
            // loading data from cache
            let data = WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "witty_data")!
            
            handle_feeds_result(jsonStr: data, isLoadedMore: false, isBackgroundRefresh: false, isCached: true)
            
            // and refreshing feed in background
            wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: true) { (jsonStr, isLoadedMore, isBackgroundRefresh) in
                if(jsonStr == "failed"){
                    self.sdk_main_init_callback("failed")
                    return
                }
                WittyFeedSDKSingleton.instance.isDataUpdated = false
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, isCached: false)
                self.sdk_main_init_callback("success")
            }
            
        } else {
            // load fresh feed
            wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh) in
                if(jsonStr == "failed"){
                    self.sdk_main_init_callback("failed")
                    return
                }
        
                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, isCached: false)
                self.sdk_main_init_callback("success")
            }
        }
    }
    
    func prepare_nativeCardFeed(card_id: String){
        let f = DateFormatter()
        f.dateFormat = "dd.MM.yyyy"
//        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "witty_data") != nil   {
//            // loading data from cache
//            let data = WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "witty_data")!
//
//            handle_feeds_result(jsonStr: data, isLoadedMore: false, isBackgroundRefresh: false, isCached: true)
//
//            // and refreshing feed in background
//            wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: true) { (jsonStr, isLoadedMore, isBackgroundRefresh) in
//                if(jsonStr == "failed"){
//                    self.sdk_main_init_callback("failed")
//                    return
//                }
//                WittyFeedSDKSingleton.instance.isDataUpdated = false
//                self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, isCached: false)
//                self.sdk_main_init_callback("success")
//            }
//
//        } else {
            // load fresh feed
        wittyFeedSdkNetworking.getStoryNativeCardData(card_id: card_id, isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh, card_id) in
                if(jsonStr == "failed"){
                    self.sdk_main_init_callback("failed")
                    return
                }
            self.handle_nativeCard_feeds_result(card_id: card_id, jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, isCached: false)
                self.sdk_main_init_callback("success")
            }
        //}
    }
    
    
    //
    //MARK: Public Methods
    //
    public func set_sdk_init_main_callback( init_callback:@escaping (String) -> Void  ){
        self.sdk_main_init_callback = init_callback
        let googleAnalytics = WittyFeedSDKGoogleAnalytics()
        googleAnalytics.sendAnalytics(typeArg: AnalyticsType.SDK, labelArg: Constants.SDK_INITIALISED)
        
    }
    
    public func init_wittyfeed_sdk(){
        prepare_feed();
    }
    
    public func init_native_card(cardId: String){
        prepare_nativeCardFeed(card_id: cardId)
    }
    
    public func update_fcm_token(new_fcm_token: String){
        if WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token") != nil {
            if(new_fcm_token == WittyFeedSDKSingleton.instance.witty_deafult.string(forKey: "wf_saved_fcm_token")){
                return
            }
        }
        wittyFeedSdkNetworking.updateFcmToken(new_fcm_token: new_fcm_token) { (status) in
            if(status == "failed"){
                print("fcm token updation failed")
            }else{
                print(status)
            }
        }
    }
    
    public func get_onefeed_view_controller() -> WittyFeedSDKOneFeedCV {
        let frameworkBundle = Bundle(for: WittyFeedSDKMain.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("OneFeed-iOS-SDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let oneFeedCollectionVC = WittyFeedSDKOneFeedCV(nibName: "WittyFeedSDKOneFeedCV", bundle: resourceBundle)
        oneFeedCollectionVC.navigationItem.hidesBackButton = true
        return oneFeedCollectionVC
    }
    
}
