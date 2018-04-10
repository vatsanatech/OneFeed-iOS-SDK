
//
//  WittyFeedSDKCardFactory.swift
//  wittyfeed_ios_api
//
//  Created by Vatsana Technologies on 30/03/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

public class WittyFeedSDKCardFactory{
    
    // Item will be put into shortest column.
    var text_size_ratio = 1.0
    
    var vc_context: UIViewController!
    
    var screen_height = WittyFeedSDKSingleton.instance.screen_height
    var screen_width = WittyFeedSDKSingleton.instance.screen_width
    
    var POSTER_SOLO_HW_RATIO = CGFloat(1)
    var POSTER_RV_HW_RATIO = CGFloat(0.8)
    var VIDEO_SOLO_HW_RATIO = CGFloat(1.1)
    var VIDEO_RV_HW_RATIO = CGFloat(0.7)
    var STORY_LIST_HW_RATIO = CGFloat(0.35)
    
    var safariDelegate: SFSafariViewControllerDelegate!
    
    // used for story list card's size calculation
    var fixed_height_of_card = 0
    var fixed_top_margin = 0
    
    
    init(text_size_ratio: Double) {
        self.text_size_ratio = text_size_ratio
        self.fixed_height_of_card = Int(screen_height*0.18)
        self.fixed_top_margin = Int(screen_height*0.03)
    }
    
    
    func getCellSize(card_type: String) -> CGSize {
        var size_to_return = CGSize()
        switch (card_type){
            
        case "poster_solo":
            size_to_return = CGSize(width: screen_width, height: screen_width * POSTER_SOLO_HW_RATIO)
            break
        case "poster_rv":
            size_to_return = CGSize(width: screen_width, height: screen_width * 0.7)
            break
        case "video_solo":
            size_to_return = CGSize(width: screen_width, height: screen_width * VIDEO_SOLO_HW_RATIO)
            break
        case "video_rv":
            size_to_return = CGSize(width: screen_width, height: screen_width * 0.45)
            break
        case "story_list":
            size_to_return = CGSize(width: screen_width, height: (screen_width * STORY_LIST_HW_RATIO))
            break
        default:
            break;
        }
        return size_to_return
    }
    
    
    func getCellSize(card_type: String, story_list_count: CGFloat) -> CGSize {
        let total_sv_height = Float( Float(( (fixed_top_margin+fixed_height_of_card) * Int(story_list_count)) ) - Float(fixed_top_margin))
        return CGSize(width: screen_width, height: CGFloat(total_sv_height) )
    }

    
    func create_single_card(card: Card, card_type: String) -> UIView {
        var m_card_type = card.card_type!
        if(m_card_type == ""){
            m_card_type = card_type
        }

        var card_to_return: mCustomUIView!
        
        switch (card_type){
        case "poster_solo":
            card_to_return = create_poster_solo_card(card: card)
            break
        case "poster_small_solo":
            card_to_return = create_small_poster_solo_card(card: card)
            break
        case "video_solo":
            card_to_return = create_video_solo_card(card: card)
            break
        case "video_small_solo":
            card_to_return = create_small_video_solo_card(card: card)
            break
        case "story_list_item":
            card_to_return = create_story_list_item_card(card: card)
            break
        default:
            break;
        }
        
        card_to_return.url_to_open = card.story_url!
        
        card_to_return!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(sender:)) ))
    
        return card_to_return
    }
    
    
    func create_cards_rv(cards: [Card], card_type: String) -> UIView {
        var card_to_return: UIView!
        switch (card_type){
        case "poster_rv":
            card_to_return = create_poster_cv(cardArrayList: cards)
            break
        case "video_rv":
            card_to_return = create_video_cv(cardArrayList: cards)
            break
        case "story_list":
            card_to_return = create_story_list(cardArrayList: cards)
            break
        default:
            break
        }
        return card_to_return
    }
    
    
    @objc func tap(sender: AnyObject){
        print("tap detected")
        let url = ((sender as! UITapGestureRecognizer).view as! mCustomUIView).url_to_open as String
        print(url)
        let controller = SFSafariViewController(url: URL(string: url)!)
        self.vc_context.present(controller, animated: true, completion: nil)
        controller.delegate = safariDelegate!
    }

    
    public func create_poster_solo_card(card: Card) -> mCustomUIView {
        let mainView = mCustomUIView( frame: CGRect(x: 0, y: 0, width: screen_width, height: CGFloat(screen_width * POSTER_SOLO_HW_RATIO)) )
       
        let cardBaseHeight = mainView.frame.size.height
        let cardBaseWidth = mainView.frame.size.width
        
        let r_1 = CGFloat(0.40)
        let r_2 = CGFloat(0.48)
        let r_3 = CGFloat(0.60)
//        let r_4 = CGFloat(0.20)
//        let r_5 = CGFloat(0.80)
//        let r_6 = CGFloat(0.82)
//        let r_7 = CGFloat(0.07)
//        let r_8 = CGFloat(18.0)
        let r_9 = CGFloat(0.16)
//        let r_10 = CGFloat(0.88)
        
        let c_1 = CGFloat(10.0)
        let c_2 = CGFloat(20.0)
        let c_3 = CGFloat(30.0)
        
        let imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: cardBaseWidth, height: cardBaseHeight-(cardBaseHeight * r_1 )))
        imgCover.backgroundColor = .lightGray
        if (card.cover_image) != nil{
            let url_string = card.cover_image
            let url = URL(string: url_string!)
            imgCover.kf.setImage(with: url)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }
        
        let font = UIFont(name: "HelveticaNeue", size: 15.0)
        let sting = card.sheild_text
        let heightStr = sting?.width(withConstrainedHeight: cardBaseHeight * 0.07, font: font!)
        let lblCatName = UILabel(frame: CGRect(x: c_1, y: cardBaseHeight * r_2, width: heightStr! + 20, height: cardBaseHeight * 0.07))
        lblCatName.text = card.sheild_text
        lblCatName.backgroundColor = UIColor.wfhexColor(hex: (card.sheild_bg!), alpha: 1.0)
        lblCatName.textAlignment = .center
        lblCatName.layer.cornerRadius = 4.0
        lblCatName.layer.masksToBounds = true
        lblCatName.font = UIFont(name: "HelveticaNeue", size: 15.0)
        lblCatName.textColor = .white

        let lblTitle = UILabel(frame: CGRect(x: c_1, y: cardBaseHeight * r_3, width: cardBaseWidth - c_2, height: cardBaseHeight * 0.25 ))
        lblTitle.text = card.story_title
        lblTitle.numberOfLines = 2
        lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        lblTitle.textColor = .black
        
        
        let logo_img = UIImageView(frame: CGRect(x: c_1, y: cardBaseHeight * 0.85, width: cardBaseHeight * 0.12, height: cardBaseHeight * 0.12 ))
        if (card.publisher_icon_url) != nil{
            let url_string = card.publisher_icon_url
            let url = URL(string: url_string!)
            logo_img.kf.setImage(with: url)
            logo_img.contentMode = .scaleAspectFill
            logo_img.clipsToBounds = true
        }
        logo_img.layer.cornerRadius = logo_img.frame.height/2
        logo_img.clipsToBounds = true
        
        let publisher_name = UILabel(frame: CGRect(x: cardBaseHeight * 0.12 + c_2, y: cardBaseHeight * 0.85, width: cardBaseWidth - ((cardBaseWidth * r_9) + c_3), height: cardBaseHeight * 0.07))
        publisher_name.text = card.publisher_name
        publisher_name.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        publisher_name.numberOfLines = 1
        publisher_name.textColor = .black
        
        let authName = UILabel(frame: CGRect(x: cardBaseHeight * 0.12 + c_2, y: cardBaseHeight * 0.85 + cardBaseHeight * 0.07 , width: cardBaseWidth - ((cardBaseWidth * r_9) + c_3), height: cardBaseHeight * 0.07 ))
        authName.text = "by \(card.user_f_name!) \(card.doa!)"
        authName.numberOfLines = 1
        authName.textColor = .lightGray
        authName.font = UIFont(name: "HelveticaNeue", size: 14.0)
      
        mainView.addSubview(imgCover)
        mainView.addSubview(lblTitle)
        mainView.addSubview(logo_img)
        mainView.addSubview(publisher_name)
        mainView.addSubview(authName)
        mainView.addSubview(lblCatName)
       
        return mainView
    }
    
    
    public func create_small_poster_solo_card(card: Card) -> mCustomUIView {
        let mainView = mCustomUIView( frame: CGRect(x: 0, y: 0, width: screen_width * POSTER_RV_HW_RATIO, height: CGFloat(screen_width * 0.7)) )
        
        let cardBaseHeight = mainView.frame.size.height
        let cardBaseWidth = mainView.frame.size.width
 
        let r_1 = CGFloat(0.40)
        let r_2 = CGFloat(0.48)
        let r_3 = CGFloat(0.60)
        //        let r_4 = CGFloat(0.20)
        //        let r_5 = CGFloat(0.80)
        //        let r_6 = CGFloat(0.82)
        //        let r_7 = CGFloat(0.07)
        //        let r_8 = CGFloat(18.0)
        let r_9 = CGFloat(0.16)
        //        let r_10 = CGFloat(0.88)
        let c_1 = CGFloat(10.0)
        let c_2 = CGFloat(20.0)
        let c_3 = CGFloat(30.0)
        
        let imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: cardBaseWidth, height: cardBaseHeight-(cardBaseHeight * r_1 )))
        imgCover.backgroundColor = .lightGray
        if (card.cover_image) != nil{
            let url_string = card.cover_image
            let url = URL(string: url_string!)
            imgCover.kf.setImage(with: url)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }
        
        let font = UIFont(name: "HelveticaNeue", size: 15.0)
        let sting = card.sheild_text
        let heightStr = sting?.width(withConstrainedHeight: cardBaseHeight * 0.07, font: font!)
        let lblCatName = UILabel(frame: CGRect(x: c_1, y: cardBaseHeight * r_2, width: heightStr! + 20, height: cardBaseHeight * 0.07))
        lblCatName.text = card.sheild_text
        lblCatName.backgroundColor = UIColor.wfhexColor(hex: (card.sheild_bg!), alpha: 1.0)
        lblCatName.textAlignment = .center
        lblCatName.layer.cornerRadius = 4.0
        lblCatName.layer.masksToBounds = true
        lblCatName.font = UIFont(name: "HelveticaNeue", size: 15.0)
        lblCatName.textColor = .white
        
        let lblTitle = UILabel(frame: CGRect(x: c_1, y: cardBaseHeight * r_3, width: cardBaseWidth - c_2, height: cardBaseHeight * 0.25 ))
        lblTitle.text = card.story_title
        lblTitle.numberOfLines = 2
        lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        lblTitle.textColor = .black
        
        
        let logo_img = UIImageView(frame: CGRect(x: c_1, y: cardBaseHeight * 0.85, width: cardBaseHeight * 0.12, height: cardBaseHeight * 0.12 ))
        if (card.publisher_icon_url) != nil{
            let url_string = card.publisher_icon_url
            let url = URL(string: url_string!)
            logo_img.kf.setImage(with: url)
            logo_img.contentMode = .scaleAspectFill
            logo_img.clipsToBounds = true
        }
        logo_img.layer.cornerRadius = logo_img.frame.height/2
        logo_img.clipsToBounds = true
        
        let publisher_name = UILabel(frame: CGRect(x: cardBaseHeight * 0.12 + c_2, y: cardBaseHeight * 0.85, width: cardBaseWidth - ((cardBaseWidth * r_9) + c_3), height: cardBaseHeight * 0.07))
        publisher_name.text = card.publisher_name
        publisher_name.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        publisher_name.numberOfLines = 1
        publisher_name.textColor = .black
        
        let authName = UILabel(frame: CGRect(x: cardBaseHeight * 0.12 + c_2, y: cardBaseHeight * 0.85 + cardBaseHeight * 0.07 , width: cardBaseWidth - ((cardBaseWidth * r_9) + c_3), height: cardBaseHeight * 0.07 ))
        authName.text = "by \(card.user_f_name!) \(card.doa!)"
        authName.numberOfLines = 1
        authName.textColor = .lightGray
        authName.font = UIFont(name: "HelveticaNeue", size: 10.0)
        
        mainView.addSubview(imgCover)
        mainView.addSubview(lblTitle)
        mainView.addSubview(logo_img)
        mainView.addSubview(publisher_name)
        mainView.addSubview(authName)
        mainView.addSubview(lblCatName)
        
        return mainView
    }
    
    
    public func create_video_solo_card(card: Card) -> mCustomUIView {
        let mainView = mCustomUIView( frame: CGRect(x: 0, y: 0, width: screen_width, height: CGFloat(screen_width * VIDEO_SOLO_HW_RATIO)) )
        let overlay = UIView( frame: CGRect(x: 0, y: 0, width: screen_width, height: CGFloat(screen_width * VIDEO_SOLO_HW_RATIO)))
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let cardBaseHeight = mainView.frame.size.height
        let cardBaseWidth = mainView.frame.size.width
        
        let c_1 = CGFloat(10.0)
        let c_2 = CGFloat(20.0)
        let c_3 = CGFloat(30.0)
        let c_4 = CGFloat(50.0)
        
        let imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: cardBaseWidth, height: cardBaseHeight ))
        imgCover.backgroundColor = .lightGray
        if (card.cover_image) != nil{
            let url_string = card.cover_image
            let url = URL(string: url_string!)
            imgCover.kf.setImage(with: url)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }
        
        let play_icon = UIImageView(frame: CGRect(x: 0, y: 0, width: c_4, height: c_4))
        play_icon.center = CGPoint(x: cardBaseWidth  / 2,
                                   y: cardBaseHeight / 2 - 20)
        play_icon.image = #imageLiteral(resourceName: "play-button")
        
        
        let font = UIFont(name: "HelveticaNeue", size: 15.0)
        let sting = card.sheild_text
        let heightStr = sting?.width(withConstrainedHeight: cardBaseHeight * 0.06, font: font!)
        let lblCatName = UILabel(frame: CGRect(x: c_1, y: cardBaseHeight * 0.62, width: heightStr! + 20.0, height: cardBaseHeight * 0.06))
        lblCatName.text = card.sheild_text
        lblCatName.backgroundColor = UIColor.wfhexColor(hex: (card.sheild_bg!), alpha: 1.0)
        lblCatName.textAlignment = .center
        lblCatName.layer.cornerRadius = 4.0
        lblCatName.layer.masksToBounds = true
        lblCatName.font = UIFont(name: "HelveticaNeue", size: 15.0)
        lblCatName.textColor = .white
        
        let lblTitle = UILabel(frame: CGRect(x: c_1, y: cardBaseHeight * 0.64, width: cardBaseWidth - c_2, height: cardBaseHeight * 0.25 ))
        lblTitle.text = card.story_title
        lblTitle.numberOfLines = 2
        lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        lblTitle.textColor = .white
        
        let logo_img = UIImageView(frame: CGRect(x: c_1, y:  cardBaseHeight * 0.85, width: cardBaseHeight * 0.12, height: cardBaseHeight * 0.12 ))
        if (card.publisher_icon_url) != nil{
            let url_string = card.publisher_icon_url
            let url = URL(string: url_string!)
            logo_img.kf.setImage(with: url)
            logo_img.contentMode = .scaleAspectFill
            logo_img.clipsToBounds = true
        }
        logo_img.layer.cornerRadius = logo_img.frame.height/2
        logo_img.clipsToBounds = true
        
        let publisher_name = UILabel(frame: CGRect(x: cardBaseHeight * 0.12 + c_2, y: cardBaseHeight * 0.85, width: cardBaseWidth - ((cardBaseHeight * 0.12) + c_3), height: cardBaseHeight * 0.07 ))
        publisher_name.text = card.publisher_name
        publisher_name.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        publisher_name.numberOfLines = 1
        publisher_name.textColor = .white
        
        let authName = UILabel(frame: CGRect(x: cardBaseHeight * 0.12 + c_2, y: cardBaseHeight * 0.85 +  cardBaseHeight * 0.05, width: cardBaseWidth - ((cardBaseHeight * 0.12) + c_3), height: cardBaseHeight * 0.07 ))
        authName.text = "by \(card.user_f_name!) \(card.doa!)"
        authName.numberOfLines = 1
        authName.textColor = .lightGray
        authName.font = UIFont(name: "HelveticaNeue", size: 14.0)
        
        mainView.addSubview(imgCover)
        mainView.addSubview(overlay)
        mainView.addSubview(play_icon)
        mainView.addSubview(lblTitle)
        mainView.addSubview(logo_img)
        mainView.addSubview(publisher_name)
        mainView.addSubview(authName)
        mainView.addSubview(lblCatName)
        
        return mainView
    }
    
    
    public func create_small_video_solo_card(card: Card) -> mCustomUIView {
        let mainView = mCustomUIView( frame: CGRect(x: 0, y: 0, width: screen_width * VIDEO_RV_HW_RATIO, height: CGFloat(screen_width * 0.45)) )
        
        let cardBaseHeight = mainView.frame.size.height
        let cardBaseWidth = mainView.frame.size.width
        let overlay = UIView( frame: CGRect(x: 0, y: 0, width: cardBaseWidth , height: cardBaseHeight))
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: cardBaseWidth, height: cardBaseHeight))
        imgCover.backgroundColor = .lightGray
        if (card.cover_image) != nil{
            let url_string = card.cover_image
            let url = URL(string: url_string!)
            imgCover.kf.setImage(with: url)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }
        
        let play_icon = UIImageView(frame: CGRect(x: 10, y: cardBaseHeight * 0.30, width: cardBaseHeight * 0.20, height: cardBaseHeight * 0.20))
        play_icon.image = #imageLiteral(resourceName: "play-button")
        
        let lblTitle = UILabel(frame: CGRect(x: 10, y: cardBaseHeight * 0.50, width: cardBaseWidth - 20, height: cardBaseHeight * 0.50 ))
        lblTitle.text = card.story_title
        lblTitle.textColor = .white
        lblTitle.numberOfLines = 2
        lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        mainView.addSubview(imgCover)
        mainView.addSubview(overlay)
        mainView.addSubview(play_icon)
        mainView.addSubview(lblTitle)
        return mainView
    }
    
    
    public func create_story_list_item_card(card: Card) -> mCustomUIView {
        let mainView = mCustomUIView( frame: CGRect(x: 0, y: 0, width: screen_width, height: CGFloat(screen_width * STORY_LIST_HW_RATIO)) )
        
        let cardBaseHeight = mainView.frame.size.height
        let cardBaseWidth = mainView.frame.size.width
        
        let r_1 = CGFloat(0.35)
        let r_3 = CGFloat(0.58)
        let r_5 = CGFloat(0.17)
        let r_8 = CGFloat(0.25)
        let r_9 = CGFloat(0.5)
        let c_1 = CGFloat(10)
        let c_2 = CGFloat(15)
        let c_3 = CGFloat(20)
        //        let c_4 = CGFloat(30)
        let c_5 = CGFloat(40)
        
        let imgCover = UIImageView(frame: CGRect(
            x: 10,
            y: 0,
            width: (cardBaseWidth * r_1),
            height: cardBaseHeight)
        )
        imgCover.backgroundColor = .lightGray
        
        let font = UIFont(name: "HelveticaNeue", size: 10.0)
        let sting = card.sheild_text
        let heightStr = sting?.width(withConstrainedHeight: cardBaseHeight * 0.15, font: font!)
        let lblCatName = UILabel(frame: CGRect(
            x: (cardBaseWidth * r_1) + c_3,
            y: cardBaseHeight * 0.05,
            width: (heightStr! + 20),
            height: cardBaseHeight * 0.15)
        )
        lblCatName.backgroundColor = UIColor.wfhexColor(hex: (card.sheild_bg!), alpha: 1.0)
        lblCatName.textAlignment = .center
        lblCatName.layer.cornerRadius = 4.0
        lblCatName.layer.masksToBounds = true
        lblCatName.textColor = .white
        lblCatName.text = card.sheild_text
        lblCatName.font = UIFont(name: "HelveticaNeue", size: 10.0)
        
        let lblTitle = UILabel(frame: CGRect(
            x: (cardBaseWidth * r_1) + c_3,
            y: cardBaseHeight * 0.22,
            width: (cardBaseWidth - (cardBaseWidth * r_1 + c_5)),
            height: cardBaseHeight * 0.40)
        )
        lblTitle.text = card.story_title
        lblTitle.numberOfLines = 2
        lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        
        let logo_img = UIImageView(frame: CGRect(
            x: (cardBaseWidth * r_1) + c_3,
            y: cardBaseHeight * 0.66,
            width: cardBaseHeight * 0.25,
            height: cardBaseHeight * 0.25)
        )
        if (card.publisher_icon_url) != nil{
            let url_string = card.publisher_icon_url
            let url = URL(string: url_string!)
            logo_img.kf.setImage(with: url)
            logo_img.contentMode = .scaleAspectFill
            logo_img.clipsToBounds = true
        }
        logo_img.layer.cornerRadius = logo_img.frame.height/2
        logo_img.clipsToBounds = true
        
        let publisher_name = UILabel(frame: CGRect(
            x: cardBaseWidth * r_1 + c_3 + cardBaseHeight * r_8 + c_1,
            y: cardBaseHeight * 0.66,
            width: ( cardBaseWidth - (cardBaseWidth * r_1 + c_1 + cardBaseHeight * r_8 + c_3) + c_1 ),
            height: cardBaseHeight * 0.66 * r_5 )
        )
        publisher_name.text = card.publisher_name

        publisher_name.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        publisher_name.numberOfLines = 1
        publisher_name.textColor = .black

        if (card.cover_image) != nil{
            let url_string = card.cover_image
            let url = URL(string: url_string!)
            imgCover.kf.setImage(with: url)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }
        
        let authName = UILabel(frame: CGRect(
            x: cardBaseWidth * r_1 + c_3 + cardBaseHeight * r_8 + c_1,
            y: cardBaseHeight * r_3 + (cardBaseHeight * r_8 * r_9 + c_1),
            width: ( cardBaseWidth - (cardBaseWidth * r_1 + c_3 + cardBaseHeight * r_8 + c_3)),
            height: cardBaseHeight * r_8 * r_9 )
        )
        
        authName.text = "by \(card.user_f_name!) \(card.doa!)"
        authName.numberOfLines = 1
        authName.textColor = .lightGray
        authName.font = UIFont(name: "HelveticaNeue", size: 12.0)
        
        mainView.addSubview(lblTitle)
        mainView.addSubview(logo_img)
        mainView.addSubview(publisher_name)
        mainView.addSubview(authName)
        mainView.addSubview(imgCover)
        mainView.addSubview(lblCatName)
        return mainView
    }
    
    func create_poster_cv(cardArrayList: [Card]) -> UIView{
        let parentCardSize = CGSize(width: screen_width, height: CGFloat(screen_width * POSTER_SOLO_HW_RATIO))
        
        let scrollView: UIScrollView = {
            let v = UIScrollView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        var cardOffset_in_sv = 0
        let fixed_left_margin = 15
        let fixed_width_of_card = Int((screen_width * POSTER_RV_HW_RATIO) * CGFloat(1.0))
        
        scrollView.frame = CGRect(x: 0, y: 0, width: parentCardSize.width, height: parentCardSize.height)
        scrollView.contentSize = CGSize(width: Int((fixed_width_of_card+fixed_left_margin)*cardArrayList.count) - fixed_left_margin, height: Int(parentCardSize.height))
        let card_height = Int(parentCardSize.height)
        
        for i in 0 ..< cardArrayList.count {
            let card_view: UIView!
            if(i == 0){
                card_view = UIView(frame: CGRect(x: cardOffset_in_sv, y: 0, width: fixed_width_of_card, height: Int(card_height)))
            } else {
                card_view = UIView(frame: CGRect(x: cardOffset_in_sv, y: 0, width: fixed_width_of_card, height: Int(card_height)))
            }
            
            let childView = create_single_card(card: cardArrayList[i], card_type: "poster_small_solo")
            card_view.addSubview(childView)
            
            scrollView.addSubview(card_view!)
            cardOffset_in_sv += fixed_width_of_card+fixed_left_margin
            
            card_view.bringSubview(toFront: childView)
        }
        return scrollView
    }
    
    
    func create_video_cv(cardArrayList: [Card]) -> UIView {
        let parentCardSize = CGSize(width: screen_width, height: CGFloat(screen_width * VIDEO_RV_HW_RATIO))
        
        let scrollView: UIScrollView = {
            let v = UIScrollView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        var cardOffset_in_sv = 0
        let fixed_left_margin = 15
        let fixed_width_of_card = Int(screen_width * VIDEO_RV_HW_RATIO * CGFloat(1.0))
        
        scrollView.frame = CGRect(x: 0, y: 0, width: parentCardSize.width, height: parentCardSize.height)
        
        scrollView.contentSize = CGSize(width: Int((fixed_width_of_card+fixed_left_margin)*cardArrayList.count) - fixed_left_margin, height: Int(parentCardSize.height))
        
        let card_height = Int(parentCardSize.height)
        
        for i in 0 ..< cardArrayList.count {
            let card_view: UIView!
            if(i == 0){
                card_view = UIView(frame: CGRect(x: cardOffset_in_sv, y: 0, width: fixed_width_of_card, height: Int(card_height)))
            } else {
                card_view = UIView(frame: CGRect(x: cardOffset_in_sv, y: 0, width: fixed_width_of_card, height: Int(card_height)))
            }
            
            card_view.addSubview(create_single_card(card: cardArrayList[i], card_type: "video_small_solo"))
            
            scrollView.addSubview(card_view!)
            cardOffset_in_sv += fixed_width_of_card+fixed_left_margin
        }
        
        return scrollView
    }
    
    
    func create_story_list(cardArrayList: [Card]) -> UIView {
        
        var cardOffset_in_sv = 0
        let total_sv_height = Float( Float(( (fixed_top_margin+fixed_height_of_card) * cardArrayList.count) ) - Float(fixed_top_margin))
        
        let container_view = UIView(frame: CGRect(x: 0, y: 0, width: Int(screen_width), height: Int(total_sv_height)))
        
        let card_width = screen_width
        
        for i in 0 ..< cardArrayList.count {
            let card_view: UIView!
            if(i == 0){
                card_view = UIView(frame: CGRect(x: 0, y: cardOffset_in_sv, width: Int(card_width), height: fixed_height_of_card))
            } else {
                card_view = UIView(frame: CGRect(x: 0, y: cardOffset_in_sv, width: Int(card_width), height: fixed_height_of_card))
            }
            
            card_view.addSubview(create_single_card(card: cardArrayList[i], card_type: "story_list_item"))
            
            container_view.addSubview(card_view!)
            cardOffset_in_sv += fixed_height_of_card + fixed_top_margin
        }
        
        return container_view
    }
    
}
