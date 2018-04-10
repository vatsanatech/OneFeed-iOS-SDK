//
//  Meta.swift
//  wittyfeed_ios_api
//
//  Created by Vatsana Technologies on 31/03/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Meta{    //This code defines the basic properties for the data you need to store.

    //MARK: Properties
    var id: Int?
    var type: String?
    var cards_length: Int?
    var sectionOrder: Int?
    var background: String?
    var background_doodle_url: String?
    var title: String?

    //MARK: Initialization
    init(){
        //default
    }
    
    //MARK: Initialization
    init(id: Int, type: String, cards_length: Int, sectionOrder: Int, background: String, background_doodle_url: String, title: String){
        // Initialize stored properties.
        self.id = id
        self.type = type
        self.cards_length = cards_length
        self.sectionOrder = sectionOrder
        self.background = background
        self.background_doodle_url = background_doodle_url
        self.title = title

    }
    
}

