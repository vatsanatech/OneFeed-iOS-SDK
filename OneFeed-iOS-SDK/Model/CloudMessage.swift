//
//  Notification.swift
//  wittyfeed_ios_notification_api
//
//  Created by Sudama Dewda on 08/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation

class CloudMessage {
    
    var title = ""
    var body = ""
    var action = ""
    
    var app_id = "", cover_image = ""
    var gcm_message_id = "", gcm_notification_action = "", id = "", notiff_agent = ""
    var story_id = "", story_title = "", story_url = ""
    
    init(dict: NSDictionary){
        if let val = dict["title"] {
            self.title = val as! String
        }
        if let val = dict["body"] {
            self.body = val as! String
        }
        if let val = dict["action"] {
            self.action = val as! String
        }
        if let val = dict["story_id"] {
            self.story_id = val as! String
        }
        if let val = dict["story_title"] {
            self.story_title = val as! String
        }
        if let val = dict["story_url"] {
            self.story_url = val as! String
        }
        if let val = dict["notiff_agent"] {
            self.notiff_agent = val as! String
        }
        if let val = dict["cover_image"] {
            self.cover_image = val as! String
        }
        if let val = dict["app_id"] {
            self.app_id = val as! String
        }
    }
    
    
}

