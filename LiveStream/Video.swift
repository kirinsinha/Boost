

//
//  Video.swift
//
//
//  Created by Dhruv Amin on 5/10/17.
//
//

import Foundation
import FirebaseDatabase
import Firebase

class Video {
    
    private var _videoRef: FIRDatabaseReference!
    
    private var _videoID: String!
    private var _videoTitle: String!
    private var _irisURL: String!
    private var _username: String!
    private var _userID: String!
    private var _boostNum: Int!
    private var _boostGoal: Int!
    private var _curViewers: Int!
    private var _totalViews: Int!
    private var _liveStatus: Bool!
    
    //Getters

    var liveStatus: Bool {
        return _liveStatus
    }
    
    var currentViewers: Int {
        return _curViewers
    }
    
    var totalViews: Int {
        return _totalViews
    }
    
    var videoID: String {
        return _videoID
    }
    
    var videoTitle: String {
        return _videoTitle
    }
    
    var irisURL: String {
        return _irisURL
    }
    
    var username: String {
        return _username
    }
    
    var userID: String {
        return _userID
    }
    
    var boostNum: Int {
        return _boostNum
    }
    
    var boostGoal: Int {
        return _boostGoal
    }
    
    //Initialization of a video
    init(videoID: String, videoInfo: Dictionary<String, AnyObject>) {
        self._videoID = videoID
        
        self._curViewers = 0
        self._totalViews = 0
        
        if let status = videoInfo["liveStatus"] as? Bool {
            self._liveStatus = status
        }
        
        if let boosts = videoInfo["boostNum"] as? Int {
            self._boostNum = boosts
        }
        
        if let boostGoal = videoInfo["boostGoal"] as? Int {
            self._boostGoal = boostGoal
        }
        
        if let title = videoInfo["videoTitle"] as? String {
            self._videoTitle = title
        }
        
        if let user = videoInfo["creatorName"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        if let userId = videoInfo["creatorId"] as? String {
            self._userID = userId
        }
        
        if let url = videoInfo["url"] as? String {
            self._irisURL = url
        }
        
        self._videoRef = DataService.dataService.VIDEO_REF.child(self._videoID)
    }
    
    //Actions
    
    func addBoost() {
        self._boostNum = self._boostNum + 1
        
        self._videoRef.child("boostNum").setValue(self._boostNum)
    }
    
    func addRemoveViewers(add: Bool) {
        if add {
            self._curViewers = self._curViewers + 1
            self._totalViews = self._totalViews + 1
        } else {
            self._curViewers = self._curViewers - 1
        }
        
        self._videoRef.child("currentViewers").setValue(self._curViewers)
        self._videoRef.child("totalViews").setValue(self._totalViews)
    }
    
    func flipLiveStatus() {
        self._liveStatus = !self._liveStatus
        
        self._videoRef.child("liveStatus").setValue(self._liveStatus)
    }
    
    //Update funcs for housekeeping with client objs
    
    func setBoost(num: Int) {
        _boostNum = num
    }
    
    func setViewers(num: Int) {
        _curViewers = num
    }
    
    func setLiveStatus(status: Bool) {
        _liveStatus = status
    }
    
}
