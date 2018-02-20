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
class WittyFeedSDKSingleton: NSObject {
    
    static var instance : WittyFeedSDKSingleton = {
        let instance = WittyFeedSDKSingleton()
        return instance
    }()
    
    var card_arr = [Card]()
    var block_arr = [Block]()
    var isDataUpdated : Bool?
    var all_card_arr = [Card]()
    var card_type: String!
    var wittyFeed_sdk_api_client: WittyFeedSDKApiClient!
    var wittyFeed_sdk_main : WittyFeedSDKMain!
    var m_GA: WittyFeedSDKGoogleAnalytics!

    let NavBarBtnColor = UIColor.wfhexColor(hex: "000000", alpha: 1.0)
    let screen_width = UIScreen.main.bounds.width
    let screen_height = UIScreen.main.bounds.height
    let witty_deafult = UserDefaults.standard

    
}
