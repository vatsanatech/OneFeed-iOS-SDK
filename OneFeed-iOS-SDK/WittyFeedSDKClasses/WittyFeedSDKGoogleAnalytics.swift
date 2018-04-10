//
//  WittyFeedSDKGoogleAnalytics.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import Alamofire

class WittyFeedSDKGoogleAnalytics {
    
    var main_payload: [String: String] = [:]
    var event_payload: [String: String] = [:]
    var screen_payload: [String: String] = [:]
    
    let GA_URL = "https://www.google-analytics.com/collect?"
    var CLIENT_UUID = ""
    
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
    
    func send_screen_tracking_GA_request(screen_name: String, callback: @escaping (String) -> Void){
        screen_payload = main_payload
        screen_payload["t"] = "screenview"
        screen_payload["cid"] = screen_name
        if ConnectionCheck.isConnectedToNetwork() {
        Alamofire.request(GA_URL, method: .post, parameters: screen_payload, encoding: URLEncoding.default, headers: nil)
            .response{ response in
                callback("GA STATUS: \(String(describing: (response.response?.statusCode)!))")
        }
        }else{
            print("disConnected")
            
        }
    }
    
    func send_event_tracking_GA_request(event_category: String, event_action: String, event_value: String, event_label: String, callback:  @escaping (String) -> Void){
        event_payload = main_payload
        event_payload["t"] = "event"
        event_payload["ec"] = event_category
        event_payload["ea"] = event_action
        event_payload["el"] = event_label
        event_payload["ev"] = event_value
        if ConnectionCheck.isConnectedToNetwork() {
            print("Connected")
            Alamofire.request(GA_URL, method: .post, parameters: event_payload, encoding: URLEncoding.default, headers: nil)
                .response{ response in
                    //callback("GA STATUS: \(String(describing: (response.response?.statusCode)!))")
            }
        }else{
            print("disConnected")
            
        }
    }
    
}
