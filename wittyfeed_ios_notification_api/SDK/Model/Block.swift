//
//  Block.swift
//  WF_NEW
//
//  Created by Aishwary Dhare on 23/09/17.
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
        if self.type! == "section" || self.type! == "banner" {
            
        } else {
            for item in card_json_arr {
                let cat_name = item["cat_name"].stringValue
                let cat_id = item["cat_id"].stringValue
                let cat_image = item["cat_image"].stringValue
                let cat_color = item["cat_color"].stringValue
                let doodle = item["doodle"].stringValue
                let card_type = item["card_type"].stringValue
                
                if( card_type == "filler" ){
                    let story_count = item["story_count"].stringValue
                    card = Card(cat_name: cat_name, cat_id: cat_id, cat_color: cat_color, cat_image: cat_image, story_count: story_count, card_type: card_type, doodle: doodle)
                } else {
                    let story_id = item["story_id"].stringValue
                    let story_title = item["story_title"].stringValue
                    let cover_image = item["cover_image"].stringValue
                    let user_id = item["user_id"].stringValue
                    let user_full_name = item["user_full_name"].stringValue
                    let doc = item["doc"].stringValue
                    let audio = item["audio"].stringValue
                    let animation_type = item["animation_type"].stringValue
                    let story_url = item["story_url"].stringValue
                    let image_url_json_arr = item["image_url"].arrayValue
                    let detail_view = item["detail_view"].arrayValue
                    
                
                    
                    card = Card(story_id: story_id, story_title: story_title, cover_image: cover_image, user_id: user_id, user_full_name: user_full_name, doc: doc, cat_name: cat_name, cat_id: cat_id, cat_image: cat_image, card_type: card_type, doodle: doodle, audio: audio, animation_type: animation_type, cat_color: cat_color, story_url: story_url, image_url_json_arr: image_url_json_arr, detail_view: detail_view, block_type: type)
                }
                card_arr.append(card)
            }
        }
    }
    
    //MARK: Initialization
    init(type: String, card_json_arr: [JSON], card_pos : Int , block_pos: Int){
        
//        var card_posi = Int()
//        var block_posi = Int()
        
//        card_posi = card_pos
//        block_posi = block_pos
        
        self.type = type
        card_arr = [Card]()
        card_arr.removeAll()
        var card: Card
        // Initialize stored properties.
        if self.type! == "section" || self.type! == "banner" {
            
        } else {
            for item in card_json_arr {
                let cat_name = item["cat_name"].stringValue
                let cat_id = item["cat_id"].stringValue
                let cat_image = item["cat_image"].stringValue
                let cat_color = item["cat_color"].stringValue
                let doodle = item["doodle"].stringValue
                let card_type = item["card_type"].stringValue
                
                if( card_type == "filler" ){
                    let story_count = item["story_count"].stringValue
                    card = Card(cat_name: cat_name, cat_id: cat_id, cat_color: cat_color, cat_image: cat_image, story_count: story_count, card_type: card_type, doodle: doodle)
                } else {
                    let story_id = item["story_id"].stringValue
                    let story_title = item["story_title"].stringValue
                    let cover_image = item["cover_image"].stringValue
                    let user_id = item["user_id"].stringValue
                    let user_full_name = item["user_full_name"].stringValue
                    let doc = item["doc"].stringValue
                    let audio = item["audio"].stringValue
                    let animation_type = item["animation_type"].stringValue
                    let story_url = item["story_url"].stringValue
                    let image_url_json_arr = item["image_url"].arrayValue
                    let detail_view = item["detail_view"].arrayValue
                    card = Card(story_id: story_id, story_title: story_title, cover_image: cover_image, user_id: user_id, user_full_name: user_full_name, doc: doc, cat_name: cat_name, cat_id: cat_id, cat_image: cat_image, card_type: card_type, doodle: doodle, audio: audio, animation_type: animation_type, cat_color: cat_color, story_url: story_url, image_url_json_arr: image_url_json_arr, detail_view: detail_view, block_type: type)
                }
                card_arr.append(card)
            }
        }
    }
    
    func requestData(completion: ((_ data: String) -> Void)) {
        let data = "Data from wherever"
         completion(data)
    }
    
}
