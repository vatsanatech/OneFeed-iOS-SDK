//
//  SharedData.swift
//  ViewAnimation
//
//  Created by Aishwary Dhare on 26/09/17.
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

}
