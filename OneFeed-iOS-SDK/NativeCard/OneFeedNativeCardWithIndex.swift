//
//  OneFeedNativeCardWithIndex.swift
//  wittyfeed_ios_api
//
//  Created by sudama dewda on 1/2/19.
//  Copyright © 2019 wittyfeed. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SafariServices

class OneFeedNativeCardWithIndex {
    
    private var INDEX: Int = 0
    var vc_context: UIViewController!
    var cardIdUrl : String!
    
    func showCard(cardId : String, nativeCardView: UIView , isVerticalImage: Bool, reference: String, views: UIViewController, INDEX: Int) -> String {
        if vc_context == nil {
            vc_context = views
            cardIdUrl = cardId
        }
        
        let imageStory = nativeCardView.viewWithTag(1001) as! UIImageView
        let titleStory = nativeCardView.viewWithTag(1002) as! UILabel
        let categoryName = nativeCardView.viewWithTag(1003) as! UILabel
        
        let cardSizeCount = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr.count
        if cardSizeCount != nil {
            
            if isVerticalImage == true {
                let url_string = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].cover_image
                let url = URL(string: url_string!)
                imageStory.kf.setImage(with: url)
            } else {
                let url_string = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].square_cover_image
                let url = URL(string: url_string!)
                imageStory.kf.setImage(with: url)
            }
            
            titleStory.text = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].story_title
            categoryName.text = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].publisher_name
            
            let googleAnalytics = WittyFeedSDKGoogleAnalytics()
            googleAnalytics.sendAnalytics(typeArg: AnalyticsType.CardView, labelArg: "Native Card")
            
            var card_to_return: mCustomUIView!
            card_to_return = mCustomUIView(frame: CGRect(x: 0, y: 0, width: nativeCardView.frame.size.width, height: nativeCardView.frame.size.height))
            
            card_to_return.url_to_open = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].story_url
            card_to_return.storyId =  WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].id
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            card_to_return.addGestureRecognizer(tapGesture)
            nativeCardView.addSubview(card_to_return)
            
        } else {
        }
        return  WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].publisher_name ?? "OneFeed"
        
    }
    
    @objc func tap(sender: AnyObject){
        let storyId = ((sender as! UITapGestureRecognizer).view as! mCustomUIView).storyId
        let googleAnalytics = WittyFeedSDKGoogleAnalytics()
        googleAnalytics.sendAnalytics(typeArg: AnalyticsType.NativeStory, labelArg: storyId ?? "")
        let url = ((sender as! UITapGestureRecognizer).view as! mCustomUIView).url_to_open as String
        let controller = SFSafariViewController(url: URL(string: url)!)
        self.vc_context.present(controller, animated: true, completion: nil)
    }
    
}
