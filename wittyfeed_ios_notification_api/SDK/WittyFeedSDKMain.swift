//
//  WittyFeedSDKMain.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import SwiftyJSON

class WittyFeedSDKMain {
    
    let mainControllerContext: UIViewController!
    let wittyFeedSdkNetworking: WittyFeedSDKNetworking
    let wittyFeedSDKApiClient: WittyFeedSDKApiClient!
    let witty_user_deafults = UserDefaults.standard
    var load_more_offset = 0
    var sdk_main_init_callback: (String) -> Void = {_ in }
    var sdk_main_did_feed_prepared_callback: (String) -> Void = {_ in }
    var block_arr = [Block]()
    
    let requestType = "waterfall";
    
    init(vc: UIViewController, wittyFeedSDKApiClient: WittyFeedSDKApiClient){
        self.mainControllerContext = vc
        self.wittyFeedSDKApiClient = wittyFeedSDKApiClient
        self.wittyFeedSdkNetworking = WittyFeedSDKNetworking(vc: mainControllerContext!, app_id: wittyFeedSDKApiClient.app_id!, api_key: wittyFeedSDKApiClient.api_key!, package_name: wittyFeedSDKApiClient.package_name!, fcm_token: wittyFeedSDKApiClient.fcm_token!, para_user_meta: wittyFeedSDKApiClient.user_meta)
    }
    
    
    func init_wittyfeed_sdk(){
        let m_GA = WittyFeedSDKGoogleAnalytics(tracking_id: "UA-40875502-17", client_fcm: wittyFeedSDKApiClient.fcm_token!)
        m_GA.send_event_tracking_GA_request(event_category: "WF_SDK", event_action: wittyFeedSDKApiClient.app_id, event_value: "1", event_label: "WF SDK initialized") { (status) in
            print(status)
        }
        
        wittyFeedSdkNetworking.verify_credentials { (status) in
            self.sdk_main_init_callback(status)
        }
    }
    

    func handle_feeds_result(jsonStr: String, isLoadedMore: Bool, isBackgroundRefresh: Bool, requestType: String, cat_name: String, cat_id: String){
        let block_json_arr = JSON.init(parseJSON: jsonStr)["data"].arrayValue
        var local_block_arr = [Block]()
        for item in block_json_arr{
            let block_type = item["type"].stringValue
            WittyFeedSDKSingleton.instance.card_type = block_type
            let card_json_arr = item["story"].arrayValue
            local_block_arr.append(Block(type: block_type, card_json_arr: card_json_arr))
        }
        block_arr = local_block_arr
        WittyFeedSDKSingleton.instance.block_arr += local_block_arr
    }
    
    
    func prepare_feed(){
        //TODO: we have bypassed prepareFeedData function from android architecture
        
        wittyFeedSdkNetworking.getStoryFeedData(isLoadedMore: false, loadmore_offset: 0, isBackgroundCacheRefresh: false) { (jsonStr, isLoadedMore, isBackgroundRefresh, requestType, cat_name, cat_id) in
            if(jsonStr == "failed"){
                self.sdk_main_did_feed_prepared_callback("failed")
                return
            }
            self.handle_feeds_result(jsonStr: jsonStr, isLoadedMore: isLoadedMore, isBackgroundRefresh: isBackgroundRefresh, requestType: requestType, cat_name: cat_name, cat_id: cat_id)
            print(self.block_arr.count)
            print(WittyFeedSDKSingleton.instance.block_arr.count)
            self.sdk_main_did_feed_prepared_callback("success")
        }
        
    }
    
    
    func set_sdk_init_main_callback( init_callback:@escaping (String) -> Void  ){
        self.sdk_main_init_callback = init_callback
    }
    
    
    func set_sdk_main_did_feed_prepared_callback( feed_callback:@escaping (String) -> Void  ){
        self.sdk_main_did_feed_prepared_callback = feed_callback
    }

    
    
}
