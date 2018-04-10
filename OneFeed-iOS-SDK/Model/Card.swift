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
    
    var card_type: String?
    var story_title: String?
    var badge_text: String?
    var publisher_url: String?
    var cover_image: String?
    var square_cover_image: String?
    var user_url: String?
    var sheild_bg: String?
    var user_f_name: String?
    var sheild_text: String?
    var doa: String?
    var publisher_name: String?
    var property_id: String?
    var story_url: String?
    var publisher_icon_url: String?
    var id: String?
    var badge_url: String?

    //MARK: Initialization
    init(){
        //default
    }
    
    //MARK: Initialization
    init(card_type: String, story_title: String, badge_text: String, publisher_url: String, cover_image: String, square_cover_image: String, user_url: String, sheild_bg: String, user_f_name: String, sheild_text: String, doa: String, publisher_name: String, property_id: String, story_url: String, publisher_icon_url: String, id: String, badge_url: String){
        // Initialize stored properties.
        self.card_type = card_type
        self.story_title = story_title
        self.badge_text = badge_text
        self.publisher_url = publisher_url
        self.cover_image = cover_image
        self.square_cover_image = square_cover_image
        self.user_url = user_url
        self.sheild_bg = sheild_bg
        self.user_f_name = user_f_name
        self.sheild_text = sheild_text
        self.doa = doa
        self.publisher_name = publisher_name
        self.property_id = property_id
        self.story_url = story_url
        self.publisher_icon_url = publisher_icon_url
        self.id = id
        self.badge_url = badge_url
    }
    

}
