//
//  WittyFeedSDKGoogleAnalytics.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import Alamofire

enum AnalyticsType: String {
    case SDK
    case NotificationReceived
    case NotificationOpened
    case Story
    case Search
    case OneFeed
    case CardView
    case NativeStory
}

class WittyFeedSDKGoogleAnalytics {
    var main_payload: [String: String] = [:]
    var event_payload: [String: String] = [:]
    var debug_mode = ""
    let GA_URL = Constants.TRACKING_URL + Constants.TRACKING
    var CLIENT_UUID = ""
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    init() {
        //Debug Mode
        #if DEBUG
        debug_mode = "iOS_Testing"
        #else
        debug_mode = "iOS_Release"
        #endif
        main_payload["appid"] = delegate.appId
        main_payload["sdkvr"] = Constants.sdk_version
        main_payload["lng"] = Locale.current.languageCode
        main_payload["pckg"] = Bundle.main.bundleIdentifier!
        main_payload["mode"] = debug_mode
        main_payload["os"] = "iOS"
        main_payload["device_id"] = UIDevice.current.identifierForVendor?.uuidString
        
    }
    
    init(tracking_id: String, client_fcm: String){
        
        if(CLIENT_UUID == ""){
            CLIENT_UUID = NSUUID().uuidString
        }
        
        var local_client_fcm = client_fcm
        if(local_client_fcm == "") {
            local_client_fcm = CLIENT_UUID
        }
        
        main_payload["v"] = "1"
        main_payload["tid"] = tracking_id
        main_payload["ds"] = "iOS SDK"
        main_payload["cid"] = CLIENT_UUID
        main_payload["uid"] = local_client_fcm
        main_payload["av"] = Constants.sdk_version
        main_payload["an"] = Bundle.main.bundleIdentifier!
        main_payload["aid"] = Bundle.main.bundleIdentifier!
        main_payload["device_id"] = UIDevice.current.identifierForVendor?.uuidString
        
    }
    
    
    func sendAnalytics(typeArg: AnalyticsType, labelArg: String){
        let args = labelArg
        switch typeArg {
        case .SDK:
            prepareSDKInitialisedTracking(eventType: "SDK initialised", appId: delegate.appId)
            break
        case .NotificationReceived:
            // prepareNotificationReceivedTracking(eventType: "notification received", storyId: <#T##String#>, notificationId: <#T##String#>, appId: Constants.APP_ID)
            break
        case .NotificationOpened:
            //prepareNotificationOpenedTracking(eventType: "notification opened", storyId: <#T##String#>, notificationId: <#T##String#>, appId: Constants.APP_ID)
            break
        case .Story:
            prepareStoryOpenedTracking(eventType: "story opened", storyId: args, source: "Feed", appId: delegate.appId)
            break
        case .NativeStory:
            prepareNativeCardStoryOpenedTracking(eventType: "story opened", storyId: args, source: "Card", appId: delegate.appId)
            
        case .Search:
            prepareSearchExecutedTracking(eventType: "search executed", searchStr: args, appId: delegate.appId)
            break
        case .OneFeed:
            prepareOneFeedViewedTracking(eventType: "oneFeed viewed", appId: delegate.appId)
            break
            
        case .CardView:
            
            prepareNativeCardViewTracking(eventType: "Card Viewed", appId: delegate.appId)
            
            
        default:
            break
        }
        
        
    }
    func sendAnalytics(appId: String, categoryArg: AnalyticsType, labelArg: String, notificationId: String){
        
        main_payload["sdkvr"] = Constants.sdk_version
        main_payload["lng"] = Locale.current.languageCode
        main_payload["cc"] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        main_payload["appuid"] = Bundle.main.bundleIdentifier!
        switch categoryArg {
        case .NotificationOpened:
            prepareNotificationOpenedTracking(eventType: "notification opened", storyId: labelArg, notificationId: notificationId, appId: appId)
            break
        case .NotificationReceived:
            prepareNotificationReceivedTracking(eventType: "notification received", storyId: labelArg, notificationId: notificationId, appId: appId)
            break
        case .Story:
            prepareStoryOpenedTracking(eventType: "story opened", storyId: labelArg, source: "", appId: appId)
            break
        default:
            break
        }
        
    }
    
    func prepareSDKInitialisedTracking(eventType: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["rsrc"] = Constants.APP_INIT
        sendRequst(payload: payload)
    }
    
    func prepareNotificationReceivedTracking(eventType: String, storyId: String, notificationId: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = "notification"
        payload["noid"] = notificationId
        sendRequst(payload: payload)
        
    }
    
    func prepareNotificationOpenedTracking(eventType: String, storyId: String, notificationId: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = "notification"
        payload["noid"] = notificationId
        sendRequst(payload: payload)
        
        
    }
    func prepareStoryOpenedTracking(eventType: String, storyId: String, source: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = source
        sendRequst(payload: payload)
    }
    
    func prepareNativeCardStoryOpenedTracking(eventType: String, storyId: String, source: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = source
        sendRequst(payload: payload)
    }
    
    func prepareSearchExecutedTracking(eventType: String, searchStr: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["srchstr"] = searchStr
        payload["rsrc"] = Constants.SEARCH_VIEWED_BY_FEED
        sendRequst(payload: payload)
        
    }
    func prepareOneFeedViewedTracking(eventType: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["rsrc"] = Constants.ONE_FEED_BY_CLICK
        sendRequst(payload: payload)
    }
    
    func prepareNativeCardViewTracking(eventType: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["rsrc"] = "Native Card"
        sendRequst(payload: payload)
    }
    
    func sendRequst(payload: [String: String]){
        
        if ConnectionCheck.isConnectedToNetwork() {
            Alamofire.request(GA_URL, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil)
                .responseJSON{ response in
                    //print(response)
            }
        } else{
            print("disConnected")
            
        }
    }
    
}
