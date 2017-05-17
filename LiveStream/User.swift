//
//  User.swift
//  LiveStream
//
//  Created by Dhruv Amin on 5/15/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//  This model helps hold all the information for a given user

import Foundation
import FirebaseDatabase
import Firebase

class User {
    
    private var _userRef: FIRDatabaseReference!
    
    private var _userId: String!
    private var _email = ""
    private var _username = ""
    private var _createdVideos: Dictionary<String, Bool>
    private var _boostedVideos: Dictionary<String, Int>
    private var _boostsLeft = 0
    
    //Getters
    
    var userId: String {
        return _userId
    }
    
    var username: String {
        return _username
    }
    
    var boostedVideos: Dictionary<String, Int> {
        return _boostedVideos
    }
    
    var createdVideos: Dictionary<String, Bool> {
        return _createdVideos
    }
    
    //Initialization of a user
    init(userId: String, userInfo: Dictionary<String, AnyObject>) {
        self._userId = userId

        if let email = userInfo["email"] as? String {
            self._email = email
        }
        
        if let boostedVideos = userInfo["boostedVideos"] as? Dictionary<String, Int> {
            self._boostedVideos = boostedVideos
        } else {
            self._boostedVideos = [:] as Dictionary<String, Int>
        }
        
        if let createdVideos = userInfo["createdVideos"] as? Dictionary<String, Bool> {
            self._createdVideos = createdVideos
        } else {
            self._createdVideos = [:] as Dictionary<String, Bool>
        }
        
        if let user = userInfo["userName"] as? String {
            self._username = user
        }
        
        if let userId = userInfo["userId"] as? String {
            self._userId = userId
        }
        
        self._userRef = DataService.dataService.USER_REF.child(self._userId)
    }
    
    
    //create a user object from an existing user
    init(snap: FIRDataSnapshot, userId: String) {
        self._userId = userId
        
        let userInfo = snap.value as! [String: Any]
        
        self._email = userInfo["email"] as! String
        self._username = userInfo["userName"] as! String
        
        self._boostedVideos = userInfo["boostedVideos"] as? Dictionary<String, Int> ?? [String:Int]()
        
        self._createdVideos = userInfo["createdVideos"] as? Dictionary<String, Bool> ?? [String:Bool]()
        
        
        self._boostsLeft = userInfo["boostsLeft"] as? Int ?? 0
        self._userRef = DataService.dataService.USER_REF.child(self._userId)
    }
    
    
    //Setters and Updaters
    
    //create or delete a video
    func createDeleteVideo(videoId: String, create: Bool) {
        self._createdVideos[videoId] = create
        self._userRef.child("createdVideos").setValue(self._createdVideos)
    }
    
    // add or remove a single boost on a video. Doesn't perform any checks yet against abuse
    func addUndoBoost(videoId: String, boost: Bool) {
        if boost {
            self._boostedVideos[videoId] = (self._boostedVideos[videoId] ?? 0) + 1
            self._boostsLeft = self._boostsLeft - 1
        } else {
            self._boostedVideos[videoId] = self._boostedVideos[videoId]! - 1
            self._boostsLeft = self._boostsLeft + 1
        }
        
        self._userRef.child("boostsLeft").setValue(self._boostsLeft)
        self._userRef.child("boostedVideos").setValue(self._boostedVideos)
    }
    
    //add boosts to the dude's account after he pays
    func addBoostBalance(num: Int) {
        self._boostsLeft = self._boostsLeft + num
        
        self._userRef.child("boostsLeft").setValue(self._boostsLeft)
    }
}
