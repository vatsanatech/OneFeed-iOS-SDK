# Vatsana Technologies Pvt. Ltd. iOS SDK API (WittyfeediOSApi)


![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
[ ![Download](https://img.shields.io/badge/Download-1.3.0-blue.svg)](https://drive.google.com/file/d/1gA4UmGAslArl1mMbjRCPu8ep9-lIRU-8/view?usp=sharing)
[![License](https://img.shields.io/badge/LICENSE-WittyFeed%20SDK%20License-blue.svg)]()

## Table Of Contents
1. [Getting Started](#1-getting-started)
2. [Example Apps](#2-example-app)
3. [License](#3-license)

## Basic concepts
The WittyfeediOSApi allows you to get WittyFeed content to display in your app using WittyfeediOSSDK.
For each item WittyfeediOSSDK will provide pre-populated views, which you can style to match your app look and feel and place where needed within your app.
The views will automatically handle everything else: click handling, reporting visibility back to WittyFeed's server and more.

Browse through the example app in this repository to see how the WittyfeediOSApi can be implemented in different types of apps.

## 1. Getting Started

### 1.1. Minimum requirements

* Minimum Deployment Target ~> 9.0
* Devices ~> iPhone

### 1.2. Incorporating the SDK

1. [Download the SDK v1.3.0 Files](https://drive.google.com/file/d/1gA4UmGAslArl1mMbjRCPu8ep9-lIRU-8/view?usp=sharing)

2. Add and copy the whole directory "SDK" into your xCode Project or xcWorkSpace,

3. Confirm for the following dependencies in your Podfile

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

}

```

### 1.4. For Waterfall Feeds of WittyFeediOSSDK

Only after SDK initialization in step 1.3,
To utilize and open waterfall feed from SDK, push/present the `WittyFeedSDKWaterfallCollectionVC` ViewController by -

```swift
// ===============================
// ==Code to open Waterfall Feed==
// ===============================

let waterfallCollectionVC = WittyFeedSDKWaterfallCollectionVC(nibName: "WittyFeedSDKWaterfallCollectionVC", bundle: nil)
self.navigationController?.pushViewController(waterfallCollectionVC, animated: true)

// ===================================
// ==Code to open Waterfall Feed End==
// ===================================
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
let notiff_manager = WittyFeedSDKNotificationManager(dict: payload_data_dict, window: self.window!)
notiff_manager.handleNotification()

// ===================================
// SDK WORK FOR NOTIFICATION ENDS HERE
// ===================================

return
}
}
```

> ## Note
> For Sample Notifications, hit this Get Request URL along with `YOUR FCM TOKEN` as a URL encoded Parameter
> http://54.174.201.35/other/get_ios_sdk_sample_notification/?fcm_token=<YOUR_FCM_TOKEN>
> You will need to create/update Apple Push Notifications Certifiates for notification testing


## 2. Example App

This repository includes an example iOS app which uses all the features of `WittyFeediOSSDK` documented above.
Install the Example App in your iPhone to test notification.
You will need to create/update Apple Push Notifications Certifiates for notification testing.


## 3. License
This program is licensed under the Vatsana Technologies Pvt. Ltd. SDK License Agreement (the “License Agreement”).  By copying, using or redistributing this program, you agree to the terms of the License Agreement.  The full text of the license agreement can be found at [   ](   ).
Copyright 2017 Vatsana Technologies Pvt. Ltd.  All rights reserved.


