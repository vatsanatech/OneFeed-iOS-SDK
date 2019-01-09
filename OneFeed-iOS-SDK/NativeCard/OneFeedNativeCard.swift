//
//  OneFeedNativeCard.swift
//  wittyfeed_ios_api
//
//  Created by sudama dewda on 12/25/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SafariServices

class OneFeedNativeCard {
    
    private var INDEX = -1;
    private var OFFSET_CARD = 1;
    private var HIT_API = true
    var safariDelegate: SFSafariViewControllerDelegate!
    var vc_context: UIViewController!
    var cardIdUrl : String!
    var fetch_more_init_main_callback: (String) -> Void = {_ in }
    var limit = 15

    func showCard(cardId : String, nativeCardView: UIView , isVerticalImage: Bool, reference: String, views: UIViewController) -> String {
        if vc_context == nil {
            vc_context = views
            cardIdUrl = cardId
        }
        
        let imageStory = nativeCardView.viewWithTag(1001) as! UIImageView
        let titleStory = nativeCardView.viewWithTag(1002) as! UILabel
        let categoryName = nativeCardView.viewWithTag(1003) as! UILabel
        let cardSizeCount = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr.count
        
        if cardSizeCount != nil {
            INDEX += 1
           // fetchNewCard(cardFeedCount: cardSizeCount ?? 0, indx: INDEX, cardId: cardId)
            if (INDEX > ((cardSizeCount ?? 1 ) - 1) ) {
                INDEX = 0
            }
            
            if INDEX == (cardSizeCount ?? 0) - 1 {
                var INDEX = cardSizeCount!
                limit = INDEX + 1
                while INDEX < limit {
                    WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.fetch_more_NativeCard_data(card_id: cardId, loadmore_offset: OFFSET_CARD, fetch_more_main_callback: { (status) in
                        self.fetch_more_init_main_callback(status)
                        if(status == "success"){
                            print ("success")
                        } else {
                            print("error")
                        }
                    })
                    INDEX = INDEX + 1
                    OFFSET_CARD = OFFSET_CARD + 1
                }
            }
            if isVerticalImage == true {
                let url_string = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].cover_image
                let url = URL(string: url_string!)
                imageStory.kf.setImage(with: url)
            } else {
                let url_string = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].square_cover_image
                let url = URL(string: url_string!)
                imageStory.kf.setImage(with: url)
            }
            categoryName.text = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].publisher_name
            titleStory.text = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].story_title
            let googleAnalytics = WittyFeedSDKGoogleAnalytics()
            googleAnalytics.sendAnalytics(typeArg: AnalyticsType.CardView, labelArg: Constants.CARD_VIEWED)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            nativeCardView.addGestureRecognizer(tapGesture)
            
        }else{
            
     
         //   fetchNewCard(cardFeedCount: cardSizeCount ?? 0, indx: INDEX, cardId: cardId)
        }
        return  WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].publisher_name ?? "OneFeed"
        
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        let storyUrl : String = WittyFeedSDKSingleton.instance.dict[cardIdUrl]?.card_arr[INDEX].story_url ?? "www.thepopple.com"
        let storyId = WittyFeedSDKSingleton.instance.dict[cardIdUrl]?.card_arr[INDEX].id
        let safariVC = SFSafariViewController(url: NSURL(string: storyUrl)! as URL)
        vc_context.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self as? SFSafariViewControllerDelegate
        let googleAnalytics = WittyFeedSDKGoogleAnalytics()
        googleAnalytics.sendAnalytics(typeArg: AnalyticsType.NativeStory, labelArg: storyId ?? "0")
        
    }
    
//    func fetchNewCard(cardFeedCount: Int, indx: Int, cardId: String) {
//
//        if cardFeedCount >= 0 {
//
//        } else {
//            if INDEX > cardFeedCount - 1 && HIT_API {
//                HIT_API = false
//                WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.fetch_more_NativeCard_data(card_id: cardId, loadmore_offset: OFFSET_CARD, fetch_more_main_callback: { (status) in
//                    self.fetch_more_init_main_callback(status)
//                    if(status == "success"){
//
//                    } else {
//                        print("error")
//                    }
//                })
//            }
//        }
//    }
}
