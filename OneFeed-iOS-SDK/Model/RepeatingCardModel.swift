//
//  RepeatingCardModel.swift
//  wittyfeed_ios_api
//
//  Created by sudama dewda on 12/25/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import SwiftyJSON

public class RepeatingCardModel{   // This code defines the basic properties for the data you need to store.
    
    //MARK: Properties
    
//    var status: String!
    var cardId : String!
    var card_arr: [Card]!
    init() {
        
    }
    //MARK: Initialization
    init(card_json_arr: [JSON], card_id: String){
       card_arr = [Card]()
       cardId = card_id
       // card_arr.removeAll()
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
