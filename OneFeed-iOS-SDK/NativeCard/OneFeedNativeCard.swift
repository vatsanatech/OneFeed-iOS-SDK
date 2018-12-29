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
    var webViewObj: WebViewViewController!
    var cardIdUrl : String!
    var fetch_more_init_main_callback: (String) -> Void = {_ in }

    public init(){}
    
    func showCard(cardId : String, view: UIView , isVerticalImage: Bool, reference: String, index: Int, views: UIViewController) -> String {
        if vc_context == nil {
            vc_context = views
            cardIdUrl = cardId
        }
        let titleStory = view.viewWithTag(1003) as! UILabel
        let imageStory = view.viewWithTag(1001) as! UIImageView
        let categoryName = view.viewWithTag(1004) as! UILabel
        let layerView = view.viewWithTag(1002)
        let card_view: mCustomUIView!
        card_view = mCustomUIView(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height))
            
            card_view.url_to_open = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[1].story_url
            card_view.storyId = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[1].id!
        layerView?.addSubview(card_view)
        
        let cardSizeCount = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr.count
        if cardSizeCount != nil {
            
            INDEX += 1
            fetchNewCard(cardFeedCount: cardSizeCount ?? 0, indx: INDEX, cardId: cardId)
            if (INDEX > ((cardSizeCount ?? 1 ) - 1) ) {
                INDEX = 0
                
            }
            let url_string = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].cover_image
            let url = URL(string: url_string!)
            layerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            imageStory.kf.setImage(with: url)
            categoryName.text = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].publisher_name
            titleStory.text = WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].story_title
            let googleAnalytics = WittyFeedSDKGoogleAnalytics()
            googleAnalytics.sendAnalytics(typeArg: AnalyticsType.CardView, labelArg: "Native Card")
           // layerView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(sender:didTap: views)) ))
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            layerView?.addGestureRecognizer(tapGesture)
          //  didSelect(url: WittyFeedSDKSingleton.instance.dict[cardId]!.card_arr[INDEX].story_url ?? "www.thepopple.com")
            
            //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(sender:viewss:)))
        }else{
            
             fetchNewCard(cardFeedCount: cardSizeCount ?? 0, indx: INDEX, cardId: cardId)
        }

        return  WittyFeedSDKSingleton.instance.dict[cardId]?.card_arr[INDEX].publisher_name ?? "OneFeed"
        
    }
    
    func didSelect(url: String) -> String{
        return url
    }

    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        print("tap")
        let storyUrl : String = WittyFeedSDKSingleton.instance.dict[cardIdUrl]?.card_arr[INDEX].story_url ?? "www.thepopple.com"
        let safariVC = SFSafariViewController(url: NSURL(string: storyUrl)! as URL)
        vc_context.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self as? SFSafariViewControllerDelegate
        let googleAnalytics = WittyFeedSDKGoogleAnalytics()
        googleAnalytics.sendAnalytics(typeArg: AnalyticsType.NativeStory, labelArg: WittyFeedSDKSingleton.instance.dict[cardIdUrl]?.card_arr[INDEX].id ?? "0")
        
    }
    
   
    func fetchNewCard(cardFeedCount: Int, indx: Int, cardId: String) {
        
        if cardFeedCount >= 0 {
            
        } else {
            if INDEX > cardFeedCount - 3 && HIT_API {
                HIT_API = false
                WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.fetch_more_NativeCard_data(card_id: cardId, loadmore_offset: OFFSET_CARD) { (status) in
                    if(status == "success"){
                       // self.collectionView?.reloadData()
                        self.HIT_API = false
                    } else {
                        print("error")
                    }
                    
                }
                
            }
            
        }

    }
    
}
