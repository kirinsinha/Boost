

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
    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, String>
        title = data["title"]! as String
    }
    
}
