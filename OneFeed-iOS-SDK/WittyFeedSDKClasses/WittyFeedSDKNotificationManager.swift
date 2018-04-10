//
//  NotificationManager.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 08/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

public class WittyFeedSDKNotificationManager {
    
    var notiff_data_dict: NSDictionary!
    var app_window: UIWindow!
    var local_client_fcm: String!
    var safariDelegate: SFSafariViewControllerDelegate!
    
    public init(dict: NSDictionary, fcm_token: String, window: UIWindow){
        notiff_data_dict = dict
        app_window = window
        local_client_fcm = fcm_token
    }
    
    public func handleNotification(){
        
        if(notiff_data_dict["notiff_agent"] != nil){
            if(notiff_data_dict["notiff_agent"] as! String != "wittyfeed_sdk"){
                return;
            }
        } else {
            return
        }
        
        var app_state = "background"
        if(UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .inactive || UIApplication.shared.applicationState == .background){
            app_state = "foreground"
        }
        
        let cloudMsg = CloudMessage(dict: notiff_data_dict)
        print(cloudMsg)
        let url = cloudMsg.story_url
        let controller = SFSafariViewController(url: URL(string: url)!)
        controller.delegate = safariDelegate!
        if(app_state == "foreground"){
            self.app_window.rootViewController?.present(controller, animated: true, completion: {
                print("notiff vc presented from foreground")
            })
        } else {
            self.app_window.rootViewController?.present(controller, animated: true, completion: {
                print("notiff vc presented from background")
            })
        }
        
        let CLIENT_UUID = NSUUID().uuidString
        
        if(local_client_fcm != nil){
            if(local_client_fcm == "") {
                local_client_fcm = CLIENT_UUID
            }
        } else {
            local_client_fcm = CLIENT_UUID
        }
        
        let m_GA = WittyFeedSDKGoogleAnalytics(tracking_id: "UA-40875502-17", client_fcm: local_client_fcm!)
        m_GA.send_event_tracking_GA_request(
            event_category: "WF NOTIFICATION",
            event_action: cloudMsg.app_id,
            event_value: "1",
            event_label: "Received - " + cloudMsg.story_id + " : " + cloudMsg.story_title
        ) { (status) in
            print(status)
        }
        print("for notification received")
        
    }
    
}

