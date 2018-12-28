//
//  WittyFeedSDKGoogleAnalytics.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

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
    private let UNIQUE_KEY = "mySuperDuperUniqueId"
    
    init() {
        //Debug Mode
        #if DEBUG
        debug_mode = "iOS_Testing"
        #else
        debug_mode = "iOS_Release"
        #endif
        
        main_payload["sdkvr"] = Constants.sdk_version
        main_payload["lng"] = Locale.current.languageCode
        main_payload["pckg"] = Bundle.main.bundleIdentifier!
        main_payload["mode"] = debug_mode
        main_payload["os"] = "iOS"
        main_payload["device_id"] = KeychainWrapper.standard.string(forKey: UNIQUE_KEY)

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
        main_payload["av"] = "1.2.0"
        main_payload["an"] = Bundle.main.bundleIdentifier!
        main_payload["aid"] = Bundle.main.bundleIdentifier!
    }
    
 
    func sendAnalytics(typeArg: AnalyticsType, labelArg: String){
        let args = labelArg
        switch typeArg {
        case .SDK:
            prepareSDKInitialisedTracking(eventType: "SDK initialised", appId: Constants.APP_ID)
            break
        case .NotificationReceived:
           // prepareNotificationReceivedTracking(eventType: "notification received", storyId: <#T##String#>, notificationId: <#T##String#>, appId: Constants.APP_ID)
            break
        case .NotificationOpened:
            //prepareNotificationOpenedTracking(eventType: "notification opened", storyId: <#T##String#>, notificationId: <#T##String#>, appId: Constants.APP_ID)
            break
        case .Story:
            prepareStoryOpenedTracking(eventType: "story opened", storyId: args, source: "Feed", appId: Constants.APP_ID)
            break
        case .NativeStory:
             prepareNativeCardStoryOpenedTracking(eventType: "story opened", storyId: args, source: "Card", appId: Constants.APP_ID)
            
        case .Search:
            prepareSearchExecutedTracking(eventType: "search executed", searchStr: args, appId: Constants.APP_ID)
            break
        case .OneFeed:
            prepareOneFeedViewedTracking(eventType: "oneFeed viewed", appId: Constants.APP_ID)
            break
            
        case .CardView:
            
            prepareNativeCardViewTracking(eventType: "Card Viewed", appId: Constants.APP_ID)
            
            
        default:
            break
        }
        
        
    }
    func sendAnalytics(appId: String, categoryArg: AnalyticsType, labelArg: String, notificationId: String){
        print(appId)
        print(AnalyticsType.NotificationReceived)
        print(labelArg)
        
        main_payload["sdkvr"] = Constants.sdk_version
        main_payload["lng"] = Locale.current.languageCode
        main_payload["cc"] = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        main_payload["appuid"] = Bundle.main.bundleIdentifier!
        print(main_payload)
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
        //print(payload)
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["rsrc"] = "App_init"
        sendRequst(payload: payload)
    }

    func prepareNotificationReceivedTracking(eventType: String, storyId: String, notificationId: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = "notification"
        payload["noid"] = notificationId
        print(payload)
        sendRequst(payload: payload)
    
    }
    
    func prepareNotificationOpenedTracking(eventType: String, storyId: String, notificationId: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = "notification"
        payload["noid"] = notificationId
        print(payload)
        sendRequst(payload: payload)
        
        
    }
    func prepareStoryOpenedTracking(eventType: String, storyId: String, source: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = source
        print(payload)
        sendRequst(payload: payload)
    }
    
    func prepareNativeCardStoryOpenedTracking(eventType: String, storyId: String, source: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["sid"] = storyId
        payload["rsrc"] = source
        print(payload)
        sendRequst(payload: payload)
    }
    
    func prepareSearchExecutedTracking(eventType: String, searchStr: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["srchstr"] = searchStr
        payload["rsrc"] = "Feed"
        sendRequst(payload: payload)
        
    }
    func prepareOneFeedViewedTracking(eventType: String, appId: String){
        var payload = main_payload
        payload["etype"] = eventType
        payload["appid"] = appId
        payload["rsrc"] = ""
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
        
    print(payload)
        if ConnectionCheck.isConnectedToNetwork() {
            //print(GA_URL,payload)
       // print(payload)
    
         Alamofire.request(GA_URL, method: .post, parameters: payload, encoding: JSONEncoding.default, headers: nil)
            .responseJSON{ response in
                print(response)
               // callback("GA STATUS: \(String(describing: (response.response?.statusCode)!))")
        }
        } else{
            print("disConnected")
            
        }
    }
    
}
