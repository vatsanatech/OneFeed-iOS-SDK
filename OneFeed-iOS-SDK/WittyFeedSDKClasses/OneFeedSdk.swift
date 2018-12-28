//
//  OneFeedSdk.swift
//  wittyfeed_ios_api
//
//  Created by sudama dewda on 27/10/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation
import UIKit

public class OneFeedSdk {
    
    let VERSION = ""
    let WATER_FALL = "Waterfall"
    let H_List = "H-List"
    let V_List = "V-List"
    let GRID = "Grid"
    
    private let customTopicParameter = ""
    private var appId = ""
    private var apiKey = ""
    private var cardId = ""
    
    init() {
        fetchAppId()
        fetchApiKey()
    }
   
    func fetchAppId() {
        do {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            //appId = delegate.appId
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchApiKey(){
        do {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            //apiKey = delegate.apiKey
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchCardId(){
        do {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            //cardId = delegate.cardId
        } catch {
            print(error.localizedDescription)
        }
    }
    // gettter method
    public func getAppId() -> String {
        return appId
    }
    
    public func getApiKey() -> String {
        return apiKey
    }
    
    public func getCardId() -> String {
        return cardId
    }
    
}
