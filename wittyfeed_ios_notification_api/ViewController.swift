//
//  ViewController.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 02/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let APP_ID = "102" //App id provided by WF
    let API_KEY = "e214460bd5cdff69ad0e13b3bf165dbe" //App access key provided by WF
    let FCM_TOKEN = "" // FCM TOKEN of the user

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ====================
        // SDK WORK STARTS HERE
        // ====================
        
        //
        // OPTIONAL to provide basic user_meta.
        // By providing user_meta your app can receive targeted content which has an higher CPM then regular content.
        //
        var user_meta: [String:String] = [:]
        
        //
        // WittyFeedSDKGender has following options = "M" for Male, "F" for Female, "O" for Other, "N" for None
        //
        user_meta["client_gender"] = "NONE"
        
        //
        // User Interests.
        // String with a max_length = 100
        //
        user_meta["client_interests"] = "love, funny, sad, politics, food, technology, DIY, friendship, hollywood, bollywood, NSFW"
        
        //
        // below code is only ***required*** for Initializing Wittyfeed Android SDK API, -- providing 'user_meta' is optional --
        //
        let wittyFeed_api_client = WittyFeedSDKApiClient(apikey: API_KEY, appid: APP_ID, fcmtoken: FCM_TOKEN, usermeta: user_meta, vc: self)
        let wittyFeed_sdk_main = WittyFeedSDKMain(vc: self, wittyFeedSDKApiClient: wittyFeed_api_client)
        
        //
        // set the closure method that works as a callback function when SDK initialzes successfully
        //
        wittyFeed_sdk_main.set_sdk_init_main_callback { (status) in
            if(status == "success"){
                print("WittyFeed SDK did Initalized Successfully")
            } else {
                // SDK Initialization Failed
                print("SDK init error")
            }
        }
        
        //
        // initializing SDK here (mandatory)
        //
        wittyFeed_sdk_main.init_wittyfeed_sdk()
        
        //
        // Fetch fresh feeds from our servers with this method call.
        // It is not mandatory if only notification feature is desired from the SDK
        //
        wittyFeed_sdk_main.prepare_feed();
        
        // ====================
        // SDK WORK ENDS HERE
        // ====================
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

