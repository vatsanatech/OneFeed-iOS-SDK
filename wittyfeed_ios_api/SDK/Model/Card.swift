//
//  File.swift
//  WF_NEW
//
//  Created by Sudama Dewda on 23/09/17.
//  Copyright © 2017 Eric Cerney. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Card{    //This code defines the basic properties for the data you need to store.
    
    
    //MARK: Properties
    
    var story_id: String?
    var story_title: String?
    var cover_image: String?
    var user_id: String?
    var user_full_name: String?
    var doc: String?
    var cat_name: String?
    var cat_id: String?
    var cat_image: String?
    var story_count: String?
    var card_type: String?
    var doodle: String?
    var audio: String?
    var animation_type: String?
    var cat_color: String?
    var story_url: String?
    var image_url: [String]?
    var detail_view: [JSON]?
    var block_type: String?
    var child_view: UIViewController?
    
    //MARK: Initialization
    init(){
        //default
    }
    
    //MARK: Initialization
    init(story_id: String, story_title: String, cover_image: String, user_id: String, user_full_name: String, doc: String, cat_name: String, cat_id: String, cat_image: String, card_type: String, doodle: String, audio: String, animation_type: String, cat_color: String, story_url: String, image_url_json_arr: [JSON], detail_view: [JSON], block_type: String){
        // Initialize stored properties.
        self.story_id = story_id
        self.story_title = story_title
        self.cover_image = cover_image
        self.user_id = user_id
        self.user_full_name = user_full_name
        self.doc = doc
        self.cat_name = cat_name
        self.cat_id = cat_id
        self.cat_image = cat_image
        self.card_type = card_type
        self.doodle = doodle
        self.audio = audio
        self.animation_type = animation_type
        self.cat_color = cat_color
        self.story_url = story_url
        self.detail_view = detail_view
        self.image_url = [String]()
        for item in image_url_json_arr {
            self.image_url?.append(item.stringValue)
        }
    }
    
    init(cat_name: String, cat_id: String, cat_color: String, cat_image:String, story_count:String, card_type:String, doodle:String){
        // Initialize stored properties.
        self.cat_name = cat_name
        self.cat_id = cat_id
        self.cat_color = cat_color
        self.cat_image = cat_image
        self.story_count = story_count
        self.card_type = card_type
        self.doodle = doodle
    }
    
}
