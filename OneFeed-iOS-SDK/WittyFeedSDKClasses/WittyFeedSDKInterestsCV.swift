//
//  WittyFeedSDKInterestsCV.swift
//  wittyfeed_ios_api
//
//  Created by Vatsana Technologies on 04/04/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import UIKit


class WittyFeedSDKInterestsCV: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let mainView = UIView( frame: CGRect(x: 0, y: 0, width: WittyFeedSDKSingleton.instance.screen_width, height: WittyFeedSDKSingleton.instance.screen_height) )
       
        activityIndicator.startAnimating()
        collectionView?.backgroundColor = .white
        collectionView?.register(UINib(nibName: "WittyFeedSDKInterestsCell", bundle: Bundle(identifier: "test.wittyfeed-ios-sdk.wittyfeed-sdk-framework")), forCellWithReuseIdentifier: "WittyFeedSDKInterestsCell")
        // Register cell classes
     

        if(WittyFeedSDKSingleton.instance.interests_block_arr.count > 0){
            self.collectionView?.reloadData()
        } else {
            WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.get_interests_list { (status) in
                if(status != "failed"){
                    self.activityIndicator.stopAnimating()
                    mainView.isHidden = true
                    self.collectionView?.reloadData()
                } else {
                    print("get interests failed")
                }
            }
        }
        
        activityIndicator.center = CGPoint(x: mainView.bounds.size.width/2, y: mainView.bounds.size.height/2)
        activityIndicator.color = UIColor.darkGray
        mainView.addSubview(activityIndicator)
        view.addSubview(mainView)
        if(WittyFeedSDKSingleton.instance.interests_block_arr.count > 0){
            mainView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        
    }
    

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(WittyFeedSDKSingleton.instance.interests_block_arr.count > 0){
            return 1
        } else {
            return 0
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return WittyFeedSDKSingleton.instance.interests_block_arr[0].card_arr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WittyFeedSDKInterestsCell", for: indexPath) as? WittyFeedSDKInterestsCell
        let card = WittyFeedSDKSingleton.instance.interests_block_arr[0].card_arr[indexPath.row]
        cell?.interestsLbl.text! = card.story_title!
        
        var isCurrentlySelected = false
        if(card.sheild_text! == "selected"){
            isCurrentlySelected = true
        }
        
        if(isCurrentlySelected){
            cell?.checkImg.image = #imageLiteral(resourceName: "active")
        } else {	
            cell?.checkImg.image = #imageLiteral(resourceName: "inactive")
        }
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WittyFeedSDKInterestsCell
        let card = WittyFeedSDKSingleton.instance.interests_block_arr[0].card_arr[indexPath.row]
        
        var isCurrentlySelected = false
        if(card.sheild_text! == "selected"){
            isCurrentlySelected = true
        }
        
        if(isCurrentlySelected){
            cell.checkImg.image = #imageLiteral(resourceName: "inactive")
            card.sheild_text! = ""
        } else {
            cell.checkImg.image = #imageLiteral(resourceName: "active")
            card.sheild_text! = "selected"
        }
        
        WittyFeedSDKSingleton.instance.wittyFeed_sdk_main.set_interests_list(interest_id: card.id!, isSelected: !isCurrentlySelected) { (status) in
            if(status != "failed"){
                print("done setting interest")
            } else {
                if(isCurrentlySelected){
                    cell.checkImg.image = #imageLiteral(resourceName: "active")
                    card.sheild_text! = "selected"
                } else {
                    cell.checkImg.image = #imageLiteral(resourceName: "inactive")
                    card.sheild_text! = ""
                }
            }
        }
    }
    
    // MARK: - WaterfallLayoutDelegate
    public func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WittyFeedSDKSingleton.instance.screen_width, height: 50)
    }

   
}
