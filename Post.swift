//
//  Post.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 22.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import Foundation


struct Post {
    let imageUrl : String
    
    init (dictionary: [String: Any]){
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
