//
//  CardPosterRV.swift
//  wittyfeed_ios_api
//
//  Created by Vatsana Technologies on 30/03/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit

public class CardPosterCV{
    
    var vc_context: UIView?
    var default_card_type: String
    var cardArrayList: [Card]!
    var screen_width = WittyFeedSDKSingleton.instance.screen_width - 50
    var screen_height = WittyFeedSDKSingleton.instance.screen_height
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var cardOffset_in_sv = 0
    var fixed_left_margin = 15
    var fixed_width_of_card = 0
    
    init(host_view: UIView, default_card_type: String, para_cards: [Card]) {
        self.vc_context = host_view
        self.cardArrayList = para_cards
        self.default_card_type = default_card_type
        self.fixed_width_of_card = Int(screen_width * CGFloat(1.0))
    }
    
    func get_constructed_rv() -> UIView{
        let view = vc_context!
        
        view.addSubview(scrollView)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        scrollView.contentSize = CGSize(width: Int((fixed_width_of_card+fixed_left_margin)*cardArrayList.count) - fixed_left_margin, height: Int(view.frame.size.height))
        
        let card_height = Int(view.frame.size.height)
        
        for i in 0 ..< cardArrayList.count {
            let card_view: UIView!
            if(i == 0){
                card_view = UIView(frame: CGRect(x: cardOffset_in_sv, y: 0, width: fixed_width_of_card, height: Int(card_height)))
            } else {
                card_view = UIView(frame: CGRect(x: cardOffset_in_sv, y: 0, width: fixed_width_of_card, height: Int(card_height)))
            }
            
            let cardFactory = WittyFeedSDKCardFactory(text_size_ratio: 1)
            card_view.addSubview(cardFactory.create_single_card(card: cardArrayList[i], card_type: default_card_type))
            
            scrollView.addSubview(card_view!)
            cardOffset_in_sv += fixed_width_of_card+fixed_left_margin
        }
        vc_context?.viewWithTag(1)
        
        return vc_context!
    }

    
}
