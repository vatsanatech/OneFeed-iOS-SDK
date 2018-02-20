//
//  WaterfallCollectionVC.swift
//  wittyfeed_ios_sdk
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 Vatsana Technologies Pvt. Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class WittyFeedSDKWaterfallCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    class CardDataClass{
        var block_postion: Int?
        var position: Int?
        var card: Card?
        var cover_img: UIImage?
        var img1: UIImage?
        var img2: UIImage?
        var img3: UIImage?
        var doodle_img: UIImage?
        var fullString = ""
        var strTitle = ""
        var stringToChange = ""
    }
    var is_fetching_data = false
    var loadmore_offset: Int = 0
    var fetch_more_init_main_callback: (String) -> Void = {_ in }
    var refreshControl: UIRefreshControl!
    let screen_width = WittyFeedSDKSingleton.instance.screen_width
    let screen_height = WittyFeedSDKSingleton.instance.screen_height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        self.navigationController?.navigationBar.tintColor = WittyFeedSDKSingleton.instance.NavBarBtnColor
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:  #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        
        WittyFeedSDKSingleton.instance.m_GA.send_event_tracking_GA_request(event_category: "WF SDK", event_action: WittyFeedSDKSingleton.instance.wittyFeed_sdk_api_client.app_id, event_value: "1", event_label: "WF Waterfall SDK initialized") { (status) in
            print(status)
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.refreshFeedData(isBackgroundCacheRefresh: false, refresh_data_main_callback: { (status) in
            print(status)
            if(status == "success"){
                self.collectionView?.reloadData()
                self.refreshControl?.endRefreshing()
            } else {
                self.refreshControl?.endRefreshing()
            }
        }, requestType: "waterfall", catName: "", catId: "")
    }
    
    public func registerNibs() {
        collectionView?.register(UINib(nibName: "M2", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "M2")
        collectionView?.register(UINib(nibName: "M2F", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "M2F")
        collectionView?.register(UINib(nibName: "S3", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "S3")
        collectionView?.register(UINib(nibName: "S2L", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "S2L")
        collectionView?.register(UINib(nibName: "LS2", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "LS2")
        collectionView?.register(UINib(nibName: "WittyFeedSDKLoaderCell", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "WittyFeedSDKLoaderCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return WittyFeedSDKSingleton.instance.block_arr.count + 1
        
    }
    
    @objc func tap(sender: AnyObject){
        
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            let wittyFeedSDKNotiffVC = WittyFeedSDKNotificationViewController(nibName: "WittyFeedSDKNotificationViewController", bundle: nil)
            let card_type = WittyFeedSDKSingleton.instance.block_arr[indexPath.row].type
            var Arr = WittyFeedSDKSingleton.instance.block_arr[indexPath.row].card_arr
            if sender.view?.tag == 0 {
                if card_type != "M2F"{
                    wittyFeedSDKNotiffVC.card = Arr![0]
                    self.present(wittyFeedSDKNotiffVC, animated:true, completion:nil)
                }
            }else if sender.view?.tag == 1{
                wittyFeedSDKNotiffVC.card = Arr![1]
                self.present(wittyFeedSDKNotiffVC, animated:true, completion:nil)
            }else if sender.view?.tag == 2{
                
                wittyFeedSDKNotiffVC.card = Arr![2]
                self.present(wittyFeedSDKNotiffVC, animated:true, completion:nil)
                
            }else if sender.view?.tag == 3{
                if card_type != "M2F"{
                    wittyFeedSDKNotiffVC.card = Arr![3]
                    self.present(wittyFeedSDKNotiffVC, animated:true, completion:nil)
                }
            }
            
        } else {
            print("collection view was tapped")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var maincell : UICollectionViewCell = UICollectionViewCell()
        
        if WittyFeedSDKSingleton.instance.block_arr.count > indexPath.row{
            let card_type = WittyFeedSDKSingleton.instance.block_arr[indexPath.row].type
            let card_ARR = WittyFeedSDKSingleton.instance.block_arr[indexPath.row].card_arr
            
            switch (card_type){
            case "M2"?:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: card_type!, for: indexPath) as? M2 {
                    
                    let v1 = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/2 - 2, height: screen_width - 50))
                    let v2: UIView = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/2 - 4, height: screen_width - 50))
                    
                    let cardf1 = CardFactory(card_view: v1, card: card_ARR![0], text_size_ratio: 1)
                    let cardf2 = CardFactory(card_view: v2, card: card_ARR![1], text_size_ratio: 1)
                    
                    cell.view1.addSubview(cardf1.card_size_view)
                    cell.view2.addSubview(cardf2.card_size_view)
                    
                    cell.view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    
                    cell.view1.tag = 0
                    cell.view2.tag = 1
                    
                    return cell
                }
                break
            case "S3"?:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: card_type!, for: indexPath) as? S3 {
                    
                    let v1: UIView = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/3 - 2, height: screen_width/1.8))
                    let v2: UIView = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/3 - 1, height: screen_width/1.8))
                    let v3: UIView = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/3 - 4, height: screen_width/1.8))
                    
                    let cardf1 = CardFactory(card_view: v1, card: card_ARR![0], text_size_ratio: 0.7)
                    let cardf2 = CardFactory(card_view: v2, card: card_ARR![1], text_size_ratio: 0.7)
                    let cardf3 = CardFactory(card_view: v3, card: card_ARR![2], text_size_ratio: 0.7)
                    
                    cell.view1.addSubview(cardf1.card_size_view)
                    cell.view2.addSubview(cardf2.card_size_view)
                    cell.view3.addSubview(cardf3.card_size_view)
                    
                    cell.view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    
                    cell.view1.tag = 0
                    cell.view2.tag = 1
                    cell.view3.tag = 2
                    
                    return cell
                }
                break
            case "M2F"?:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: card_type!, for: indexPath) as? M2F {
                    
                    //  let v1: UIView = UIView(frame: CGRect(x: 2, y: 0, width: Constants_WF.screen_width/2 - 2, height:  Constants_WF.screen_width * 17/100 - 2))
                    let v2: UIView = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/2 - 2, height: screen_width * 83/100))
                    let v3: UIView = UIView(frame: CGRect(x: 2, y: 0, width: screen_width/2 - 4, height: v2.frame.height))
                    // let v4: UIView = UIView(frame: CGRect(x: 2, y: 2, width: Constants_WF.screen_width/2 - 4, height: v1.frame.height))
                    
                    // let cardf1 = CardFactory(card_view: v1, card: card_ARR![0], text_size_ratio: 15)
                    let cardf2 = CardFactory(card_view: v2, card: card_ARR![1], text_size_ratio: 0.9)
                    let cardf3 = CardFactory(card_view: v3, card: card_ARR![2], text_size_ratio: 0.9)
                    //  let cardf4 = CardFactory(card_view: v4, card: card_ARR![3], text_size_ratio: 15)
                    
                    //  cell.filler1.addSubview(cardf1.card_size_view)
                    cell.view1.addSubview(cardf2.card_size_view)
                    cell.view2.addSubview(cardf3.card_size_view)
                    //   cell.filler2.addSubview(cardf4.card_size_view)
                    
                    //  cell.filler1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    //  cell.filler2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    
                    // cell.filler1.tag = 0
                    cell.view1.tag = 1
                    cell.view2.tag = 2
                    // cell.filler2.tag = 3
                    
                    return cell
                }
                break
            case "LS2"?:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: card_type!, for: indexPath) as? LS2 {
                    
                    let v1: UIView = UIView(frame: CGRect(x: 2, y: 0, width: (screen_width / 3) * 2 - 6, height: screen_width))
                    let v2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screen_width/3, height: screen_width * 50/100))
                    let v3: UIView = UIView(frame: CGRect(x: 0, y: 2, width: screen_width/3, height: screen_width * 50/100 - 2))
                    
                    let cardf1 = CardFactory(card_view: v1, card: card_ARR![0], text_size_ratio: 1)
                    let cardf2 = CardFactory(card_view: v2, card: card_ARR![1], text_size_ratio: 0.8)
                    let cardf3 = CardFactory(card_view: v3, card: card_ARR![2], text_size_ratio: 0.8)
                    
                    cell.view_large.addSubview(cardf1.card_size_view)
                    cell.view_s1.addSubview(cardf2.card_size_view)
                    cell.view_s2.addSubview(cardf3.card_size_view)
                    
                    cell.view_large.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view_s1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view_s2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    
                    cell.view_large.tag = 0
                    cell.view_s1.tag = 1
                    cell.view_s2.tag = 2
                    
                    return cell
                }
                break
            case "S2L"?:
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: card_type!, for: indexPath) as? S2L{
                    
                    let v1: UIView = UIView(frame: CGRect(x: 2, y: 0, width: (screen_width / 3), height: screen_width * 50/100))
                    let v2: UIView = UIView(frame: CGRect(x: 2, y: 2, width: (screen_width / 3), height: screen_width * 50/100 - 2))
                    let v3: UIView = UIView(frame: CGRect(x: 2, y: 0, width: (screen_width / 3) * 2 - 6, height: screen_width))
                    
                    let cardf1 = CardFactory(card_view: v1, card: card_ARR![0], text_size_ratio: 0.8)
                    let cardf2 = CardFactory(card_view: v2, card: card_ARR![1], text_size_ratio: 0.8)
                    let cardf3 = CardFactory(card_view: v3, card: card_ARR![2], text_size_ratio: 1)
                    
                    cell.view_s1.addSubview(cardf1.card_size_view)
                    cell.view_s2.addSubview(cardf2.card_size_view)
                    cell.view_large.addSubview(cardf3.card_size_view)
                    
                    cell.view_s1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view_s2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    cell.view_large.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
                    
                    cell.view_s1.tag = 0
                    cell.view_s2.tag = 1
                    cell.view_large.tag = 2
                    
                    return cell
                }
                break
                
            default:
                break;
                
            }
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WittyFeedSDKLoaderCell", for: indexPath) as? WittyFeedSDKLoaderCell
            cell?.loaderActivity.startAnimating()
            maincell = cell!
        }
        
        return maincell
    }
    
    
    // MARK: - WaterfallLayoutDelegate
    public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var size = CGSize(width: screen_width, height: screen_height)
        if WittyFeedSDKSingleton.instance.block_arr.count > indexPath.row {
            switch WittyFeedSDKSingleton.instance.block_arr[indexPath.row].type {
            case "section":
                size = CGSize(width: 0, height: 0)
            case "LS2":
                size =  CGSize(width: screen_width, height: screen_width)
            case "M2":
                size =  CGSize(width: screen_width, height: screen_width - 50)
            case "M2F":
                size =  CGSize(width: screen_width, height: screen_width)
            case "S2L":
                size =  CGSize(width: screen_width, height: screen_width)
            case "Banner":
                size = CGSize(width: 0, height: 0)
            case "S3":
                size =  CGSize(width: screen_width, height: screen_width/1.8)
            default:
                size = CGSize(width: 0, height: 0)
            }
            return size
        }else{
            return CGSize(width: screen_width, height: 50)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = WittyFeedSDKSingleton.instance.block_arr.count - 1
        if (is_fetching_data == false) {
            if(indexPath.row == lastElement){
                is_fetching_data = true
                loadmore_offset += 1
                WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.fetch_more_data(fetch_more_main_callback: { (status) in
                    self.fetch_more_init_main_callback(status)
                    print(status)
                    if(status == "success"){
                        self.collectionView?.reloadData()
                        self.is_fetching_data = false
                    } else {
                        print("error")
                    }
                }, loadmore_offset: loadmore_offset)
            }
        }
        
        var size = CGSize(width: screen_width, height: 50)
        if WittyFeedSDKSingleton.instance.block_arr.count > indexPath.row {
            switch WittyFeedSDKSingleton.instance.block_arr[indexPath.row].type {
            case "section":
                size = CGSize(width: 0, height: 0)
            case "LS2":
                size =  CGSize(width: screen_width, height: screen_width)
            case "M2":
                size =  CGSize(width: screen_width, height: screen_width - 50)
            case "M2F":
                size =  CGSize(width: screen_width, height: screen_width)
            case "S2L":
                size =  CGSize(width: screen_width, height: screen_width)
            case "Banner":
                size = CGSize(width: 0, height: 0)
            case "S3":
                size =  CGSize(width: screen_width, height: screen_width/1.8)
            default:
                size = CGSize(width: 0, height: 0)
            }
            //return size
        }else if WittyFeedSDKSingleton.instance.block_arr.count == 0 {
            
        }
        cell.frame.size = size
        
    }
    func set_fetch_more__init_main_callback( init_callback:@escaping (String) -> Void  ){
        self.fetch_more_init_main_callback = init_callback
    }
    
}
