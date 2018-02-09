//
//  Notification.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 08/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation

class CloudMessage {
    
    var title = ""
    var body = ""
    var action = ""
    
    var animation_type = "", app_id = "", audio = ""
    var card_type = "", cat_color = "", cat_id = "", cat_image = "", cat_name = "", cover_image = ""
    var detail_view = "", doc = "", doodle = "", gcm_message_id = "", gcm_notification_action = "", id = "", notiff_agent = ""
    var story_id = "", story_title = "", story_url = "", user_full_name = "", user_id = ""
    
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
        if let val = dict["animation_type"] {
            self.animation_type = val as! String
        }
        if let val = dict["audio"] {
            self.audio = val as! String
        }
        if let val = dict["card_type"] {
            self.card_type = val as! String
        }
        if let val = dict["detail_view"] {
            self.detail_view = val as! String
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
        if let val = dict["user_full_name"] {
            self.user_full_name = val as! String
        }
        if let val = dict["user_id"] {
            self.user_id = val as! String
        }
        if let val = dict["notiff_agent"] {
            self.notiff_agent = val as! String
        }
        if let val = dict["cover_image"] {
            self.cover_image = val as! String
        }
        if let val = dict["cat_name"] {
            self.cat_name = val as! String
        }
        if let val = dict["cat_id"] {
            self.cat_id = val as! String
        }
        if let val = dict["cat_color"] {
            self.cat_color = val as! String
        }
        if let val = dict["doc"] {
            self.doc = val as! String
        }
        if let val = dict["doodle"] {
            self.doodle = val as! String
        }
        if let val = dict["app_id"] {
            self.app_id = val as! String
        }
    }
    
    
}
