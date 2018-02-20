//
//  CardFactory.swift
//  wittyfeed_ios_sdk
//
//  Created by Sudama Dewda on 02/02/18.
//  Copyright © 2018 Vatsana Technologies Pvt. Ltd. All rights reserved.
//


import Foundation
import SwiftyJSON
import Kingfisher

public class CardFactory{
    // Item will be put into shortest column.
    var cardDataObject = CardDataClass()
    
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
    
    var mainView: UIView!
    var doodleImg: UIImageView!
    var card_view1 : UIView!
    var card_view2 : UIView!
    var lblTitle: UILabel!
    var imgCover: UIImageView!
    var card_size_view: UIView!
    var card_doodle_iv: UIImageView!
    var block: Block?
    var title_str: String!
    var card: Card?
    var vc_context: UIView?
    var card_type: String?
    var lblCatName: UILabel!
    var text_size_ratio : Float!
    var scrollVw: UIScrollView!
    var img1: UIImageView!
    var img2: UIImageView!
    var img3: UIImageView!
    
    init(card_view: UIView, card: Card, text_size_ratio: Float ) {
        self.card_size_view = card_view
        self.card = card
        self.text_size_ratio = text_size_ratio
        create_card(type: card.card_type!)
    }
    
    func create_card(type: String){
      
        switch (type){
            case "filler":
                create_filler()
                break
            case "card_type_1":
                create_card_type_1()
                break
            case "card_type_2":
                create_card_type_2()
                break
            case "card_type_3":
                create_card_type_3()
                break
            case "card_type_4":
                create_card_type_4()
                break
            case "card_type_5":
                create_card_type_5()
                break
            case "card_type_6":
                create_card_type_6()
                break
            case "card_type_7":
                create_card_type_7()
                break
            
            default:
                break;
        }
        
    }
    
    public func create_card_type_1() {
        
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        lblTitle = UILabel(frame: CGRect(x: 5, y: 10, width: card_view1.frame.width - 10, height: 50))
        scrollVw = UIScrollView(frame: CGRect(x: -25, y: lblTitle.frame.height + 15, width: card_view1.frame.width + 50, height: card_view1.frame.height - (lblTitle.frame.height + 70)))
        imgCover = UIImageView(frame: CGRect(x: 0, y: lblTitle.frame.height + 15, width: scrollVw.frame.width, height: scrollVw.frame.height))
        lblCatName = UILabel(frame: CGRect(x: 5, y: imgCover.frame.height + 70, width: card_view1.frame.width - 10, height: 50))
       
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .white
        lblTitle.numberOfLines = 3
        lblTitle.font = lblTitle.font.withSize(CGFloat(text_size_ratio))
       
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 3
        lblCatName.font = lblCatName.font.withSize(CGFloat(text_size_ratio))
        self.scrollVw.isUserInteractionEnabled = false
       //self.scrollVw.backgroundColor = Color.black.withAlphaComponent(0.3)
        self.scrollVw?.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: -195))
        
      
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
        if (card?.doodle) != nil{
            let url = URL(string: (card?.doodle)!)
            doodleImg.kf.setImage(with: url)
            self.doodleImg.contentMode = .scaleAspectFill
            self.doodleImg.clipsToBounds = true
        }
    
        doodleImg.image = UIImage(named: (card?.doodle)!)
        imgCover.image = UIImage(named: (card?.doodle)!)
        
        card_size_view.addSubview(mainView)
        mainView.addSubview(doodleImg)
        scrollVw.addSubview(imgCover)
        card_view1.addSubview(lblTitle)
        card_view1.addSubview(scrollVw)
        card_view1.addSubview(lblCatName)
        card_size_view.addSubview(card_view1)
       
      //  return card_size_view
    }
    
    public func create_card_type_2() {
        
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        lblCatName = UILabel(frame: CGRect(x: 5, y: 10, width: card_view1.frame.width - 10, height: 20))
        imgCover = UIImageView(frame: CGRect(x: 0, y: lblCatName.frame.height + 15, width: card_view1.frame.width, height: card_view1.frame.height * 35/100))
        
        card_view2 = UIView(frame: CGRect(x: 20, y: lblCatName.frame.height + imgCover.frame.height, width: card_view1.frame.width - 20, height: card_view1.frame.height * 60/100))
        
        card_view2.backgroundColor = .white
        lblTitle = UILabel(frame: CGRect(x: 5, y: 10, width: card_view2.frame.width - 10, height: card_view2.frame.height - 20))
        card_doodle_iv = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view2.frame.width, height: card_view1.frame.height - (imgCover.frame.height + lblCatName.frame.height)))
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 5
        lblTitle.font = lblTitle.font.withSize(CGFloat(text_size_ratio))
         lblTitle.sizeToFit()
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 3
        lblCatName.font = lblCatName.font.withSize(CGFloat(text_size_ratio))
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
        if (card?.doodle) != nil{
            let url = URL(string: (card?.doodle)!)
            doodleImg.kf.setImage(with: url)
            self.doodleImg.contentMode = .scaleAspectFill
            self.doodleImg.clipsToBounds = true
        }
        
        doodleImg.image = UIImage(named: (card?.doodle)!)
        imgCover.image = UIImage(named: (card?.doodle)!)
    
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        card_view2.backgroundColor = .white
        
        card_size_view.addSubview(mainView)
        mainView.addSubview(doodleImg)
        card_view1.addSubview(imgCover)
        card_view1.addSubview(lblCatName)
        card_view2.addSubview(card_doodle_iv)
        card_view2.addSubview(lblTitle)
        card_view1.addSubview(card_view2)
        card_size_view.addSubview(card_view1)
    
        //return card_size_view
    }
    
    public func create_card_type_3() {
        
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        lblCatName = UILabel(frame: CGRect(x: 5, y: 10, width: card_view1.frame.width - 10, height: 20))
        imgCover = UIImageView(frame: CGRect(x: 0, y: lblCatName.frame.height + 15, width: card_view1.frame.width, height: card_view1.frame.height * 30/100))
        
        card_view2 = UIView(frame: CGRect(x: 10, y: lblCatName.frame.height + imgCover.frame.height + 20, width: card_view1.frame.width - 20, height: card_view1.frame.height * 30/100))
        
        lblTitle = UILabel(frame: CGRect(x: 5, y: 10, width: card_view2.frame.width - 10, height: card_view2.frame.height - 10))
        card_doodle_iv = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view2.frame.width, height: card_view1.frame.height - (imgCover.frame.height + lblCatName.frame.height)))
        
        img1 = UIImageView(frame: CGRect(x: 2, y: imgCover.frame.height + card_view2.frame.height + 50, width: (card_view1.frame.width/3) - 2.5, height: card_view1.frame.height * 20/100))
        img2 = UIImageView(frame: CGRect(x: img1.frame.width + 4, y: imgCover.frame.height + card_view2.frame.height + 50, width: (card_view1.frame.width/3) - 2.5, height: card_view1.frame.height * 20/100))
        img3 = UIImageView(frame: CGRect(x: (img1.frame.width*2) + 6, y: imgCover.frame.height + card_view2.frame.height + 50, width: (card_view1.frame.width/3) - 2.5, height: card_view1.frame.height * 20/100))
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 3
        lblTitle.font = lblTitle.font.withSize(CGFloat(text_size_ratio))
        lblTitle.sizeToFit()
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 3
        lblCatName.font = lblCatName.font.withSize(CGFloat(text_size_ratio))
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
        if (card?.doodle) != nil{
            let url = URL(string: (card?.doodle)!)
            doodleImg.kf.setImage(with: url)
            self.doodleImg.contentMode = .scaleAspectFill
            self.doodleImg.clipsToBounds = true
        }
        
        doodleImg.image = UIImage(named: (card?.doodle)!)
        imgCover.image = UIImage(named: (card?.doodle)!)
        img1?.image = #imageLiteral(resourceName: "images")
        img2?.image = #imageLiteral(resourceName: "images")
        img3?.image = #imageLiteral(resourceName: "images")
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        
        card_view2.backgroundColor = .white
        card_size_view.addSubview(mainView)
        mainView.addSubview(doodleImg)
        card_view1.addSubview(imgCover)
        card_view1.addSubview(lblCatName)
       // card_view1.addSubview(img1)
       // card_view1.addSubview(img2)
       // card_view1.addSubview(img3)
        card_view2.addSubview(card_doodle_iv)
        card_view2.addSubview(lblTitle)
        card_view1.addSubview(card_view2)
        card_size_view.addSubview(card_view1)
        
        //return card_size_view
    }
    public func create_card_type_4() {
        
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        lblCatName = UILabel(frame: CGRect(x: 5, y: 10, width: card_view1.frame.width - 10, height: 20))
        imgCover = UIImageView(frame: CGRect(x: 0, y: lblCatName.frame.height + 15, width: card_view1.frame.width, height: card_view1.frame.height * 30/100))
        
        card_view2 = UIView(frame: CGRect(x: 0, y: lblCatName.frame.height + imgCover.frame.height + 10, width: card_view1.frame.width, height: card_view1.frame.height - (lblCatName.frame.height + imgCover.frame.height + 10)))
        
        lblTitle = UILabel(frame: CGRect(x: 5, y: 10, width: card_view2.frame.width - 10, height: card_view2.frame.height - 10))
        card_doodle_iv = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view2.frame.width, height: card_view1.frame.height - (imgCover.frame.height + lblCatName.frame.height)))
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 5
        lblTitle.font = lblTitle.font.withSize(CGFloat(text_size_ratio))
        lblTitle.sizeToFit()
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 3
        lblCatName.font = lblCatName.font.withSize(CGFloat(text_size_ratio))
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
        if (card?.doodle) != nil{
            let url = URL(string: (card?.doodle)!)
            doodleImg.kf.setImage(with: url)
            self.doodleImg.contentMode = .scaleAspectFill
            self.doodleImg.clipsToBounds = true
        }
        
        doodleImg.image = UIImage(named: (card?.doodle)!)
        imgCover.image = UIImage(named: (card?.doodle)!)
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        
        card_view2.backgroundColor = .white
        card_size_view.addSubview(mainView)
        mainView.addSubview(doodleImg)
        card_view1.addSubview(imgCover)
        card_view1.addSubview(lblCatName)
        card_view2.addSubview(card_doodle_iv)
        card_view2.addSubview(lblTitle)
        card_view1.addSubview(card_view2)
        card_size_view.addSubview(card_view1)
        
       // return card_size_view
    }
    public func create_card_type_5() {
        
         mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        lblCatName = UILabel(frame: CGRect(x: 5, y: 10, width: card_view1.frame.width - 10, height: 20))
        imgCover = UIImageView(frame: CGRect(x: 0, y: lblCatName.frame.height + 15, width: card_view1.frame.width, height: card_view1.frame.height * 30/100))
        
        card_view2 = UIView(frame: CGRect(x: 20, y: (lblCatName.frame.height + imgCover.frame.height) - 10, width: card_view1.frame.width - 40, height: card_view1.frame.height * 60/100))
        
        lblTitle = UILabel(frame: CGRect(x: 5, y: 10, width: card_view2.frame.width - 10, height: card_view2.frame.height - 10))
        card_doodle_iv = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view2.frame.width, height: card_view1.frame.height - (imgCover.frame.height + lblCatName.frame.height)))
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 5
        lblTitle.font = lblTitle.font.withSize(CGFloat(text_size_ratio))
        lblTitle.sizeToFit()
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 3
        lblCatName.font = lblCatName.font.withSize(CGFloat(text_size_ratio))
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
        if (card?.doodle) != nil{
            let url = URL(string: (card?.doodle)!)
            doodleImg.kf.setImage(with: url)
            self.doodleImg.contentMode = .scaleAspectFill
            self.doodleImg.clipsToBounds = true
        }
        
        doodleImg.image = UIImage(named: (card?.doodle)!)
        imgCover.image = UIImage(named: (card?.doodle)!)
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        
        card_view2.backgroundColor = .white
        
        card_size_view.addSubview(mainView)
        mainView.addSubview(doodleImg)
        card_view1.addSubview(imgCover)
        card_view1.addSubview(lblCatName)
        card_view2.addSubview(card_doodle_iv)
        card_view2.addSubview(lblTitle)
        card_view1.addSubview(card_view2)
        card_size_view.addSubview(card_view1)
   
       // return card_size_view
    }
    
    public func create_card_type_6() {
         mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view2 = UIView(frame: CGRect(x: 20, y: 20, width: card_view1.frame.width - 40, height: card_view1.frame.height * 76/100))
        imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view2.frame.width, height: card_view2.frame.height * 45/100 ))
        lblTitle = UILabel(frame: CGRect(x: 5, y: imgCover.frame.height + 5, width: card_view2.frame.width - 10, height: card_view2.frame.height * 55/100))
        
        lblCatName = UILabel(frame: CGRect(x: 5, y: card_view2.frame.height + 40, width: card_view1.frame.width - 10, height: 20))
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 5
        lblTitle.font = lblTitle.font.withSize(CGFloat(text_size_ratio))
        lblTitle.sizeToFit()
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 3
        lblCatName.font = lblCatName.font.withSize(CGFloat(text_size_ratio))
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
        if (card?.doodle) != nil{
            let url = URL(string: (card?.doodle)!)
            doodleImg.kf.setImage(with: url)
            self.doodleImg.contentMode = .scaleAspectFill
            self.doodleImg.clipsToBounds = true
        }
        
        doodleImg.image = UIImage(named: (card?.doodle)!)
        imgCover.image = UIImage(named: (card?.doodle)!)
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        card_size_view.addSubview(mainView)
        mainView.addSubview(doodleImg)
        card_view2.backgroundColor = .white
        card_view2.addSubview(imgCover)
        card_view1.addSubview(lblCatName)
        card_view2.addSubview(lblTitle)
        card_view1.addSubview(card_view2)
        card_size_view.addSubview(card_view1)
        
    //    return card_size_view
    }
    
    
    public func create_card_type_7(){
       
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view2 = UIView(frame: CGRect(x: 0, y: 0, width: card_view1.frame.width, height: card_view1.frame.height))
      
        imgCover = UIImageView(frame: CGRect(x: 0, y: 0, width: card_view1.frame.width, height: card_view1.frame.height))
        
        lblCatName = UILabel(frame: CGRect(x: 5, y: 10, width: card_view2.frame.width - 10, height: 20))
        lblTitle = UILabel(frame: CGRect(x: 5, y: CGFloat(card_view2.frame.height - CGFloat(50*text_size_ratio) - 10), width: card_view2.frame.width - 10, height: CGFloat(50*text_size_ratio) ) )
        
        card_view1.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        
        lblTitle.text = card?.story_title
        lblTitle.textColor = .white
        lblTitle.font = UIFont.boldSystemFont(ofSize: CGFloat(14)*CGFloat(text_size_ratio))
        lblTitle.numberOfLines = 5
        lblTitle.sizeToFit()
        
        if(lblTitle.numberOfLines > 3){
            lblTitle.frame.origin.y = CGFloat(card_view2.frame.height - CGFloat(60*text_size_ratio) - 10)
            lblTitle.frame.size.height = CGFloat(60*text_size_ratio)
        }
        
        lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.textAlignment = .right
        lblCatName.numberOfLines = 3
        lblCatName.font = UIFont.boldSystemFont(ofSize: CGFloat(12.0)*CGFloat(text_size_ratio))
        
        if (card?.cover_image) != nil{
            let url = URL(string: (card?.cover_image)!)
            imgCover.kf.setImage(with: url)
        
            self.imgCover.contentMode = .scaleAspectFill
            self.imgCover.clipsToBounds = true
        }
        
       card_view2.backgroundColor = UIColor.black.withAlphaComponent(0.5)
       card_view1.addSubview(imgCover)
       card_view2.addSubview(lblCatName)
       card_view2.addSubview(lblTitle)
       card_view1.addSubview(card_view2)
       card_size_view.addSubview(card_view1)
  
    }
  
    public func create_filler(){
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        doodleImg = UIImageView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        card_view1 = UIView(frame: CGRect(x: 0, y: 0, width: card_size_view.frame.width, height: card_size_view.frame.height))
        lblCatName = UILabel(frame: CGRect(x: 5, y: 5, width: card_view1.frame.width - 10, height: 40))
        //lblCatName.text = card?.cat_name
        lblCatName.textColor = .white
        lblCatName.numberOfLines = 1
        lblCatName.font = lblCatName.font.withSize(15)
        mainView.backgroundColor = UIColor.wfhexColor(hex: (card?.cat_color)!, alpha: 0.8)
        card_size_view.addSubview(mainView)
        card_view1.addSubview(lblCatName)
        card_size_view.addSubview(card_view1)
        
     //   return card_size_view
    }
    
    func startImageTransition(imgCover: UIImageView, image: UIImage){
        // possible animations - slideInRight , zoomIn , slideInLeft , slideInDown , slideInUp
        imgCover.isHidden = false
        switch(("slideInRight")){
        case "zoomIn":
            self.imgCover.image = image
            self.zoomImage()
            break
        case "slideInRight":
            let default_originX = self.imgCover.frame.origin.x
            self.imgCover.frame.origin.x = self.imgCover.frame.width*(-1)
            self.imgCover.image = image
            self.slideIn_XAxis(default_originX: default_originX)
            break
        case "slideInLeft":
            let default_originX = self.imgCover.frame.origin.x
            self.imgCover.frame.origin.x = self.imgCover.frame.width*(2)
            self.imgCover.image = image
            self.slideIn_XAxis(default_originX: default_originX)
            break
        case "slideInDown":
            let default_originY = self.imgCover.frame.origin.y
            self.imgCover.frame.origin.y = self.imgCover.frame.width*(-1)
            self.imgCover.image = image
            self.slideIn_YAxis(default_originY: default_originY)
            break
        case "slideInUp":
            let default_originY = self.imgCover.frame.origin.y
            self.imgCover.frame.origin.y = self.imgCover.frame.width*(2)
            self.imgCover.image = image
            self.slideIn_YAxis(default_originY: default_originY)
            break
        default:
            self.imgCover.image = image
            break
        }
    }
    
    //MARK: - Animation
    
    func labelTransition(label: UILabel) {
        UIView.animate(withDuration: 1, animations: {
            label.center = CGPoint(x: label.center.x-400, y: label.center.y)
        })
    }
    
    func imageTransition(_ image: UIImageView, subtype: String) {
        let transition = CATransition()
        transition.type = kCATransitionPush
        if subtype == "left" {
            transition.subtype = kCATransitionFromLeft
        } else if subtype == "right" {
            transition.subtype = kCATransitionFromRight
        } else if subtype == "top" {
            transition.subtype = kCATransitionFromTop
        } else {
            transition.subtype = kCATransitionFromBottom
        }
        
       // scrollVw.layer.add(transition, forKey: nil)
     //   scrollVw.addSubview(image)
    }
    
    
    //MARK: Transitions: of waterfall layout
    
    func zoomImage() {
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.imgCover?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                self.imgCover?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    func slideIn_XAxis(default_originX: CGFloat){
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.imgCover.frame.origin.x = default_originX
        }, completion: {(_ finished: Bool) -> Void in
            //do nothing
        })
    }
    func slideIn_YAxis(default_originY: CGFloat){
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.imgCover.frame.origin.y = default_originY
        }, completion: {(_ finished: Bool) -> Void in
            //do nothing
        })
    }
}
