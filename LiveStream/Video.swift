

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
    
    //Getters
    
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
    
    //Initialization of a video
    init(videoID: String, videoInfo: Dictionary<String, AnyObject>) {
        self._videoID = videoID
        
        if let boosts = videoInfo["boostNum"] as? Int {
            self._boostNum = boosts
        }
        
        if let title = videoInfo["videoTitle"] as? String {
            self._videoTitle = title
        }
        
        if let user = videoInfo["creator"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        if let userId = videoInfo["userID"] as? String {
            self._userID = userId
        }
        
        if let url = videoInfo["url"] as? String {
            self._irisURL = url
        }
        
        self._videoRef = DataService.dataService.VIDEO_REF.child(self._videoID)
    }
    
}
