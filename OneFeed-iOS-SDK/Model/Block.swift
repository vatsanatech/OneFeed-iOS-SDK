//
//  Block.swift
//  WF_NEW
//
//  Created by Sudama Dewda on 23/09/17.
//  Copyright © 2017 Eric Cerney. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Block{   // This code defines the basic properties for the data you need to store.

    //MARK: Properties
    
    var type: String!
    var section_name: String!
    var card_arr: [Card]!

    //MARK: Initialization
    init(type: String, card_json_arr: [JSON]){
        self.type = type
        card_arr = [Card]()
        card_arr.removeAll()
        var card: Card

        // Initialize stored properties.
        
        for item in card_json_arr {
            let card_type = item["card_type"].stringValue
            let story_title = item["story_title"].stringValue
            let badge_text = item["badge_text"].stringValue
            let publisher_url = item["publisher_url"].stringValue
            let cover_image = item["cover_image"].stringValue
            let square_cover_image = item["square_cover_image"].stringValue
            let user_url = item["user_url"].stringValue
            let sheild_bg = item["sheild_bg"].stringValue
            let user_f_name = item["user_f_name"].stringValue
            let sheild_text = item["sheild_text"].stringValue
            let doa = item["doa"].stringValue
            let publisher_name = item["publisher_name"].stringValue
            let property_id = item["property_id"].stringValue
            let story_url = item["story_url"].stringValue
            let publisher_icon_url = item["publisher_icon_url"].stringValue
            let id = item["id"].stringValue
            let badge_url = item["badge_url"].stringValue
            
            card = Card(card_type: card_type, story_title: story_title, badge_text: badge_text, publisher_url: publisher_url, cover_image: cover_image, square_cover_image: square_cover_image, user_url: user_url, sheild_bg: sheild_bg, user_f_name: user_f_name, sheild_text: sheild_text, doa: doa, publisher_name: publisher_name, property_id: property_id, story_url: story_url, publisher_icon_url: publisher_icon_url, id: id, badge_url: badge_url)
            
            card_arr.append(card)
        }
    }
}
