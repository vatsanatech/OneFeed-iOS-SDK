# Vatsana Technologies Pvt. Ltd. OneFeed-iOS-SDK

> # Note
> WittyFeed SDK API is now `OneFeed iOS SDK`,
> New v1.0.12 made live on 18 April' 2018

![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
[ ![Pods](https://img.shields.io/badge/Pods-1.0.12-blue.svg)](#1-getting-started)
[![License](https://img.shields.io/badge/LICENSE-WittyFeed%20SDK%20License-blue.svg)]()

## Table Of Contents
1. [Getting Started](#1-getting-started)
2. [Example Apps](#2-example-app)
3. [License](#3-license)

## Basic concepts
OneFeed brings you new revolutionary way to monetize your App Business. OneFeed provides engaging content from top publishers in your app, and through the [Viral9 Dashboard](https://viral9.com) you can track your earning with the content consumption.

[Viral9 is World's Top Paying Network](https://viral9.com)

OneFeed SDK has its core competency at its personalised feed recommendation algorithms and lightweight architecture.

### Features

* OneFeed ready-to-deploy feed layout
* Notification service

Browse through the example app in this repository to see how the OneFeed SDK can be implemented in different types of apps.

## 1. Getting Started

### 1.1. Minimum requirements

* Minimum Deployment Target ~> 9.0
* Devices ~> iPhone

### 1.2. Incorporating the SDK

1. [Integrate using CocoaPods](#1-getting-started)

```groovy
pod 'OneFeed-iOS-SDK', :git => 'https://github.com/vatsanatech/OneFeed-iOS-SDK', :tag => ‘1.0.12’
```

2. Confirm for the following dependencies in your Podfile

```groovy
Alamofire (4.6.0)
SwiftyJSON (4.0.0)
Kingfisher (4.6.1)
Firebase/Core (4.8.2) // for notification service only
Firebase/Messaging (4.8.2)  // for notification service only
```

> ## Notice
> We encourage developers to always check for latest SDK version and refer to its updated documentation to use it.


### 1.3. Using the SDK

```swift

class MainViewController: UIViewController {

let APP_ID = "<YOUR_APP_ID>" //App id provided by WF
let API_KEY = "<YOUR_API_KEY>" //App access key provided by WF
let FCM_TOKEN = "" // FCM TOKEN of the user

override func viewDidLoad() {
  super.viewDidLoad()

    if let temp = InstanceID.instanceID().token(){
        FCM_TOKEN = temp
    }

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
    // below code is only ***required*** for Initializing Wittyfeed iOS SDK API, -- providing 'user_meta' is optional --
    //
    WittyFeedSDKSingleton.instance.wittyFeed_sdk_api_client = WittyFeedSDKApiClient(apikey: API_KEY, appid: APP_ID, fcmtoken: FCM_TOKEN, usermeta: user_meta)

    WittyFeedSDKSingleton.instance.wittyFeed_sdk_main = WittyFeedSDKMain(wittyFeedSDKApiClient:  WittyFeedSDKSingleton.instance.wittyFeed_sdk_api_client)

    //
    // set the closure method that works as a callback function when SDK initialzes successfully
    //
    WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.set_sdk_init_main_callback { (status) in

        if(status == "success"){
            //
            // Do necessary actions here after initializing OneFeed-SDK
            //
            print("WittyFeed SDK did Initalized Successfully")
        } else {
            //
            // If SDK initialization failes
            //
            print("SDK init error")
        }
    }

    //
    // initializing SDK here (mandatory)
    //
    WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.init_wittyfeed_sdk()

    // ==================
    // SDK WORK ENDS HERE
    // ==================

  }
  
}

```

### 1.4. For ready-to-deploy OneFeed Layout

Only after SDK initialization in step 1.3,
To utilize and open waterfall feed from SDK, push/present the `WittyFeedSDKWaterfallCollectionVC` ViewController by -

```swift
  // ========================
  // ==Code to open OneFeed==
  // ========================

  let onefeed_vc = WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.get_onefeed_view_controller()
  self.navigationController?.pushViewController(onefeed_vc, animated: true)

  // ============================
  // ==Code to open OneFeed End==
  // ============================
```

### 1.5. For Notifications Service of WittyFeediOSSDK

In your AppDelegate, update your `userNotificationCenter (willPresent..)` and `userNotificationCenter (didRecieve..)` with the code below

```swift
// Firebase notification received
@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {

  // =====================================
  // SDK WORK FOR NOTIFICATION STARTS HERE
  // =====================================

  completionHandler([.alert, .badge, .sound])

  // ===================================
  // SDK WORK FOR NOTIFICATION ENDS HERE
  // ===================================

  return
}

@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
  // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
  // print("Handle push from background or closed\(response.notification.request.content.userInfo)")
  print("Handle push from background or closed")

    // =====================================
    // SDK WORK FOR NOTIFICATION STARTS HERE
    // =====================================

    //
    // Parse the data payload in cloud message into an dictionary, we will this dictionary forward into WittyFeedSDK
    //
    let payload_data_dict = response.notification.request.content.userInfo as NSDictionary

    //
    // Create an object of WittyFeedSDKNotificationManager to handle the notifications from Engage9 only
    // it will not interfere or disrupt your notifications
    //
    let fcm_token = InstanceID.instanceID().token()
    let notiff_manager = WittyFeedSDKNotificationManager(dict: payload_data_dict, fcm_token: fcm_token!, window: self.window!)
    notiff_manager.safariDelegate = self as SFSafariViewControllerDelegate
    notiff_manager.handleNotification()

    // ===================================
    // SDK WORK FOR NOTIFICATION ENDS HERE
    // ===================================

    return
  }
}

// when firebase token updates in host app
func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Token:- \(fcmToken)")
    // =====================================
    // SDK WORK FOR NOTIFICATION STARTS HERE
    // =====================================
    if(WittyFeedSDKSingleton.instance.wittyFeed_sdk_main != nil){
        WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.update_fcm_token(new_fcm_token: fcmToken)
    } else {
        let witty_sdk_main = WittyFeedSDKMain(wittyFeedSDKApiClient: WittyFeedSDKApiClient(apikey: "", appid: "", fcmtoken: fcmToken) )
        witty_sdk_main.update_fcm_token(new_fcm_token: fcmToken)
    }
    // ===================================
    // SDK WORK FOR NOTIFICATION ENDS HERE
    // ===================================
}
```

> ## Note
> For Sample Notifications, hit this Get Request URL along with `YOUR FCM TOKEN` as a URL encoded Parameter
> http://54.174.201.35/other/get_ios_sdk_sample_notification/?fcm_token=<YOUR_FCM_TOKEN>
> You will need to create/update Apple Push Notifications Certifiates for notification testing


## 2. Example App

This repository includes an example iOS app which uses all the features of `OneFeed-iOS-SDK` documented above.
Install the Example App in your iPhone to test notification.
You will need to create/update Apple Push Notifications Certifiates for notification testing.


## 3. License
This program is licensed under the Vatsana Technologies Pvt. Ltd. SDK License Agreement (the “License Agreement”).  By copying, using or redistributing this program, you agree to the terms of the License Agreement.  The full text of the license agreement can be found at [   ](   ).
Copyright 2017 Vatsana Technologies Pvt. Ltd.  All rights reserved.


