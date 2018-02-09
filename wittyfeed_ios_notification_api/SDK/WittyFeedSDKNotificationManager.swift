//
//  NotificationManager.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 08/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseInstanceID

class WittyFeedSDKNotificationManager {
    
    var notiff_data_dict: NSDictionary!
    var app_window: UIWindow!
    
    init(dict: NSDictionary, window: UIWindow){
        notiff_data_dict = dict
        app_window = window
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
        
        let wittyFeedSDKNotiffVC = WittyFeedSDKNotificationViewController(nibName: "WittyFeedSDKNotificationViewController", bundle: nil)
        let cloudMsg = CloudMessage(dict: notiff_data_dict)
        print(cloudMsg)
        wittyFeedSDKNotiffVC.cloudMsg = cloudMsg
        wittyFeedSDKNotiffVC.app_state = app_state
        if(app_state == "foreground"){
            self.app_window.rootViewController?.present(wittyFeedSDKNotiffVC, animated: true, completion: {
                print("notiff vc presented from foreground")
            })
        } else {
            self.app_window.rootViewController?.present(wittyFeedSDKNotiffVC, animated: true, completion: {
                print("notiff vc presented from background")
            })
        }
        
        let CLIENT_UUID = NSUUID().uuidString
        var local_client_fcm = InstanceID.instanceID().token()
        
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
