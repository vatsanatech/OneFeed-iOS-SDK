//
//  WittyFeedSDKNotificationViewController.swift
//  wittyfeed_ios_notification_api
//
//  Created by Aishwary Dhare on 08/02/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import FirebaseInstanceID

class WittyFeedSDKNotificationViewController: UIViewController, UIScrollViewDelegate {
    
    var cloudMsg: CloudMessage!
    var animationInProcess = false
    var webViewContainer: UIView!
    var webView: UIWebView!
    var card: Card!
    let text_size_ratio = 1
    
    var card_size_view: UIView!
    var card_view1: UIView!
    var card_view2: UIView!
    var imgCover: UIImageView!
    var lblCatName: UILabel!
    var lblTitle: UILabel!
    var readMoreButton: UIButton!
    var default_read_more_frame: CGRect!
    var default_back_button_height: CGFloat!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var backButton_HeightConstraint: NSLayoutConstraint!
    var app_state = ""
    var foreground_button_text = "Back to App"
    var background_button_text = "Go Back"
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(cloudMsg != nil) {
            print(app_state)
            if(app_state == "background"){
                backButton.setTitle(background_button_text, for: .normal)
            } else {
                backButton.setTitle(foreground_button_text, for: .normal)
            }
            print(cloudMsg.title)
            self.view.backgroundColor = hexStringToUIColor(hex: cloudMsg.cat_color)
            let json_arr_temp = [JSON]()
            
            card = Card(story_id: cloudMsg.story_id, story_title: cloudMsg.story_title, cover_image: cloudMsg.cover_image, user_id: cloudMsg.user_id, user_full_name: cloudMsg.user_full_name, doc: cloudMsg.doc, cat_name: cloudMsg.cat_name, cat_id: cloudMsg.cat_id, cat_image: cloudMsg.cat_image, card_type: cloudMsg.card_type, doodle: cloudMsg.doodle, audio: cloudMsg.audio, animation_type: cloudMsg.animation_type, cat_color: cloudMsg.cat_color, story_url: cloudMsg.story_url, image_url_json_arr: json_arr_temp, detail_view:[JSON](), block_type: "NA")
            
            create_card_type_7()
            
            if(cloudMsg.action == "WittyFeedSDKContentViewActivity"){
                showStoryWebView()
            }
            
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true) {
            print("WittyFeedSDKViewController closed!")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func create_card_type_7(){
        
        card_size_view = self.cardView
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: (card_size_view?.frame.width)!, height: (card_size_view?.frame.height)!))
        card_view2 = UIView(frame: CGRect(x: 0, y: 0, width: card_view1.frame.width, height: card_view1.frame.height))
        
        imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view1.frame.width, height: card_view1.frame.height))
        
        lblCatName = UILabel(frame: CGRect(x: 5, y: 15, width: card_view2.frame.width - 20, height: 50))
        lblTitle = UILabel(frame: CGRect(x: 5, y: card_view2.frame.height * 68/100, width: card_view2.frame.width - 10, height: card_view2.frame.height * 30/100))
        
        readMoreButton = UIButton(frame: CGRect(x: 0, y: card_view2.frame.height-50, width: card_view2.frame.width, height: 50))
        
        // card_view1.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .white
        lblTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(30*text_size_ratio))
        lblTitle.numberOfLines = 5
        lblTitle.sizeToFit()
        
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.textAlignment = .right
        lblCatName.numberOfLines = 3
        lblCatName.font = UIFont.boldSystemFont(ofSize: CGFloat(20.0))
        
        readMoreButton.setTitle("Read More", for: .normal)
        readMoreButton.setTitleColor(UIColor.white, for: .normal)
        readMoreButton.addTarget(self, action: #selector(self.tappedToOpenStoryWebView), for: UIControlEvents.touchDown)
        self.default_read_more_frame = readMoreButton.frame
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            imgCover.contentMode = .scaleAspectFill
            imgCover.clipsToBounds = true
        }
        
        webViewContainer = UIView(frame: CGRect(x: 0, y: card_view2.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        webViewContainer.backgroundColor = UIColor.clear
        webView.backgroundColor = UIColor.clear
        webView.layoutMargins.top = card_view2.frame.size.height-30
        let url_str = "https://www.wittyfeed.com/amp/" + (card?.story_id!)!
        print("story_url: \(url_str)")
        let url_req = URLRequest(url: URL(string: url_str)!)
        let raw_html = "<!DOCTYPE html><html><body style='height:100%; background-color:#ffffff;'><div style='height:100%; padding-top:10px; padding-bottom:10px; background-color:#046fc2; color:#fff;'><center>WittyFeed</center></div></body></html>"
        webView.loadHTMLString(raw_html, baseURL: nil)
        webView.loadRequest(url_req)
        
        webViewContainer.addSubview(webView)
        webView.scrollView.delegate = self
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.didPanGesture))
        self.webViewContainer.addGestureRecognizer(panGesture)
        self.view.addGestureRecognizer(panGesture)
        
        card_view2.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        card_view1.addSubview(imgCover)
        card_view2.addSubview(lblCatName)
        card_view2.addSubview(lblTitle)
        card_view2.addSubview(readMoreButton)
        card_view2.addSubview(webViewContainer)
        card_view1.addSubview(card_view2)
        self.cardView.addSubview(card_view1)
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        if animationInProcess == false {
            if(scrollView.contentOffset.y == 0.0) {
                scrollView.layer.removeAllAnimations()
                scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
                scrollView.bounces = true
            } else if scrollView.contentOffset.y > 0.0 {
                scrollView.bounces = false
            } else if scrollView.contentOffset.y <= -25.0 {
                self.hideStoryWebView()
            }
        }
    }
    
    //MARK: - Pan gesture to drag webview
    
    @objc public func didPanGesture(recognizer: UIPanGestureRecognizer) {
        if(!animationInProcess){
            let translation = recognizer.translation(in: self.view)
//            print(translation.y)
            self.webViewContainer.isHidden = false
//            print(self.webViewContainer.frame.origin.y)
            if(self.webViewContainer.frame.origin.y+translation.y > 0 && self.webViewContainer.frame.origin.y+translation.y <= self.view.frame.height){
//                print("comingUP")
                self.webViewContainer.frame = CGRect(x: 0, y: self.webViewContainer.frame.origin.y+translation.y, width: self.view.frame.width, height: self.view.frame.height)
                self.webViewContainer.layoutIfNeeded()
            }
            
            if recognizer.state == .ended{
                if (self.webViewContainer.frame.origin.y <= self.view.frame.height/1.4){
//                    print("anim status: \(animationInProcess)")
                    showStoryWebView()
                } else {
//                    print("anim status: \(animationInProcess)")
                    hideStoryWebView()
                }
            }
            recognizer.setTranslation(CGPoint.zero, in: self.webViewContainer)
        }
    }
    
    func showStoryWebView() {
        self.animationInProcess = true
        self.default_read_more_frame = self.readMoreButton.frame
        self.backButton.isHidden = true
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.webViewContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        self.webView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.webViewContainer.frame.height-20)
                        self.readMoreButton.frame = CGRect(x: 0, y: self.view.frame.height, width: self.default_read_more_frame.width, height: self.default_read_more_frame.height)
                        self.webViewContainer.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.animationInProcess = false
            self.webView.scrollView.bounces = true
            self.webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
            self.send_event_notification_GA()
        })
    }
    
    func hideStoryWebView() {
        self.animationInProcess = true
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.webViewContainer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
                        self.readMoreButton.frame = self.default_read_more_frame!
                        self.webViewContainer.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.webViewContainer.isHidden = true
            self.webView.frame = CGRect(x: 0, y: 0, width: self.card_view2.frame.width, height: self.card_view2.frame.height)
            self.backButton.isHidden = false
            self.animationInProcess = false
        })
    }
    
    func send_event_notification_GA(){
        let CLIENT_UUID = NSUUID().uuidString
        var local_client_fcm = InstanceID.instanceID().token()
        
        if(local_client_fcm != nil){
            if(local_client_fcm == "") {
                local_client_fcm = CLIENT_UUID
            }
        } else {
            local_client_fcm = CLIENT_UUID
        }
        
        let m_GA = WittyFeedSDKGoogleAnalytics(tracking_id: "UA-40875502-17", client_fcm: local_client_fcm!)
        m_GA.send_event_tracking_GA_request(
            event_category: "WF NOTIFICATION",
            event_action: cloudMsg.app_id,
            event_value: "1",
            event_label: "Opened - " + cloudMsg.story_id + " : " + cloudMsg.story_title
        ) { (status) in
            print(status)
        }
        print("for notification opened")
    }
    
    func send_event_story_GA(){
        let CLIENT_UUID = NSUUID().uuidString
        var local_client_fcm = InstanceID.instanceID().token()
        
        if(local_client_fcm != nil){
            if(local_client_fcm == "") {
                local_client_fcm = CLIENT_UUID
            }
        } else {
            local_client_fcm = CLIENT_UUID
        }
        
        let m_GA = WittyFeedSDKGoogleAnalytics(tracking_id: "UA-40875502-17", client_fcm: local_client_fcm!)
        m_GA.send_event_tracking_GA_request(
            event_category: "WF Story",
            event_action: cloudMsg.app_id,
            event_value: "1",
            event_label: "" + cloudMsg.story_id + " : " + cloudMsg.story_title
        ) { (status) in
            print(status)
        }
        print("for story read")
    }
    
    @objc public func tappedToOpenStoryWebView(){
//        print("Button Tapped")
        self.webViewContainer.isHidden = false
        showStoryWebView()
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
