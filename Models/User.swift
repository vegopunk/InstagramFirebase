//
//  User.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 25.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import Foundation



struct User{
    
    let uid: String
    let username : String
    let profileImageURl : String
    
    init(uid: String , dictionary : [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURl = dictionary["profileImageURl"] as? String ?? ""
        
    }
}
