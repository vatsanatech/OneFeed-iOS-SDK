//
//  captions.swift
//  wittyfeed_ios_sdk
//
//  Created by Vatsana Technologies on 25/01/18.
//  Copyright © 2018 Vatsana Technologies. All rights reserved.
//

import Foundation
import SwiftyJSON

public class caption{    // This code defines the basic properties for the data you need to store.
    
    
    //MARK: Properties
    
    var story_id: String?
    var media_source: String?
    var image_order: String?
    var caption: String?
    var image_url: String?
    var image_desc: String?
    var image_width: String?
    var image_height: String?
   
    //MARK: Initialization
    init(){
        //default
    }
    //MARK: Initialization
    init(story_id: String, media_source: String, image_order: String, caption: String, image_url: String, image_desc: String, image_width: String, image_height: String){
        
        // Initialize stored properties.
        self.story_id = story_id
        self.media_source = media_source
        self.image_order = image_order
        self.caption = caption
        self.image_url = image_url
        self.image_desc = image_desc
        self.image_width = image_width
        self.image_height = image_height
        
    }
    
  
    
}

