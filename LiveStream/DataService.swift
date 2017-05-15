//
//  DataService.swift
//  LiveStream
//
//  Created by Dhruv Amin on 5/14/17.
//  Copyright © 2017 com.continuum. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = FIRDatabase.database().reference()
    private var _USER_REF = FIRDatabase.database().reference().child("users")
    private var _VIDEO_REF = FIRDatabase.database().reference().child("videos")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
    
        let currentUser = FIRDatabase.database().reference().child("users").child(userID)
    
        return currentUser
    }

    var VIDEO_REF: FIRDatabaseReference {
        return _VIDEO_REF
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        //saves a user to the database
        USER_REF.child(uid).setValue(user)
    }
    
    func createNewVideo(videoID: String, videoInfo: Dictionary<String, AnyObject>) {
        VIDEO_REF.child(videoID).setValue(videoInfo)
    }

}
