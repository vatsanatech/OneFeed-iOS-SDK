//
//  TrackingModel.swift
//  wittyfeed_ios_api
//
//  Created by sudama dewda on 12/17/18.
//  Copyright © 2018 wittyfeed. All rights reserved.
//

import Foundation

public class TrackingModel {
    
    var sdkVersion: String = ""
    var language: String = ""
    var packageId: String = ""
    var deviceId: String = ""
    var networkType: String = ""
    var eventType: String = ""
    var appId: String = ""
    var storyId: String = ""
    var resource: String = ""
    var notificationId: String = ""
    var appUserId: String = ""
    var searchString: String = ""
    var os: String = ""
    var mode: String = ""
    var action: String = ""
    var category: String = ""
    var token: String = ""
    
    
    init(dict: NSDictionary){
        if let val = dict["sdkvr"] {
            self.sdkVersion = val as! String
        }
        if let val = dict["lng"] {
            self.language = val as! String
        }
        if let val = dict["pckg"] {
            self.packageId = val as! String
        }
        if let val = dict["device_id"] {
            self.deviceId = val as! String
        }
        if let val = dict["ntype"] {
            self.networkType = val as! String
        }
        if let val = dict["etype"] {
            self.eventType = val as! String
        }
        if let val = dict["appid"] {
            self.appId = val as! String
        }
        if let val = dict["sid"] {
            self.storyId = val as! String
        }
        if let val = dict["rsrc"] {
            self.resource = val as! String
        }
        if let val = dict["noid"] {
            self.notificationId = val as! String
        }
        if let val = dict["appuid"] {
            self.appUserId = val as! String
        }
        if let val = dict["srchstr"] {
            self.searchString = val as! String
        }
        if let val = dict["os"] {
            self.os = val as! String
        }
        if let val = dict["mode"] {
            self.mode = val as! String
        }
        if let val = dict["uaction"] {
            self.action = val as! String
        }
        if let val = dict["category"] {
            self.category = val as! String
        }
        if let val = dict["ftoken"] {
            self.token = val as! String
        }
        
    }
    
    public func setAction(action: String) {
        self.action = action
    }
    public func setCategory(category: String) {
        self.category = category
    }
    
    public func setToken(token: String) {
        self.token = token
    }
    
    public func setMode(mode: String) {
        self.mode = mode
    }
    
    public func setOs(os: String) {
        self.os = os
    }
    
    public func getLanguage() -> String {
        return language
    }
    
    public func setLanguage(language: String) {
        self.language = language
    }
    public func setDeviceId(deviceId: String) {
        self.deviceId = deviceId
    }
    public func setEventType(eventType: String) {
        self.eventType = eventType
    }
    public func getAppId() -> String  {
        return appId
    }
    
    public func setAppId(appId: String) {
        self.appId = appId
    }
    
    public func getStoryId() -> String {
        return storyId
    }
    
    public func setStoryId(storyId: String) {
        self.storyId = storyId
    }
    
    public func getResource()-> String {
        return resource
    }
    
    public func setResource(resource: String) {
        self.resource = resource
    }
    
    public func setNotificationId(notificationId: String) {
        self.notificationId = notificationId
    }
    
    public func getAppUserId() -> String {
        return appUserId
    }
    
    public func setAppUserId(appUserId: String) {
        self.appUserId = appUserId
    }
    
    public func getSearchString()-> String {
        return searchString
    }
    
    public func setSearchString(searchString: String) {
        self.searchString = searchString
    }
}
