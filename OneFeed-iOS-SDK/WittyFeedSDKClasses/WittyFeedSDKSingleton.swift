//
//  SharedData.swift
//  ViewAnimation
//
//  Created by Sudama Dewda on 26/09/17.
//  Copyright © 2016 Aishwary Dhare. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

public class WittyFeedSDKSingleton: NSObject {
    
    public static var instance : WittyFeedSDKSingleton = {
        let instance = WittyFeedSDKSingleton()
        return instance
    }()
    
    var block_arr = [Block]()
    var search_blocks_arr = [Block]()
    var interests_block_arr = [Block]()
    
    var isDataUpdated : Bool? = false
    var card_type: String!
    public var wittyFeed_sdk_api_client: WittyFeedSDKApiClient!
    public var wittyFeed_sdk_main : WittyFeedSDKMain!
    var m_GA: WittyFeedSDKGoogleAnalytics!

    let NavBarColor = UIColor.wfhexColor(hex: "e5ebef", alpha: 1.0)
    let ImgBgColor = UIColor.wfhexColor(hex: "f0f0f0", alpha: 1.0)
    let NavBarPLNCatColor = UIColor.wfhexColor(hex: "0xEEEEEE", alpha: 1.0)
    let screen_width = UIScreen.main.bounds.width
    let screen_height = UIScreen.main.bounds.height
    let witty_deafult = UserDefaults.standard
    var user_id = ""
    
}

