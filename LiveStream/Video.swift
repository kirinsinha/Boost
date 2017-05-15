

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
    
    var ref: FIRDatabaseReference?
    var title: String?
    var user: FIRUser?
    var irisurlid: String?
    var videoID: String?
    
    init (dbref: FIRDatabaseReference?, user: FIRUser?, streamTitle: String?) {
        
        self.ref = dbref!
        self.user = user
        self.title = streamTitle
        self.videoID = ref?.child("Broadcasts").childByAutoId().key

        }
    
    func sendToFirebase(){
        let JSONPackage: String = "Broadcasts/[\(String(describing: user?.email)), \(videoID)]"
        ref?.setValue(JSONPackage)

    }
}
