//
//  Post.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 22.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import Foundation


struct Post {
    let user: User
    let imageUrl : String
    let caption : String
    
    init (user: User , dictionary: [String: Any]){
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
