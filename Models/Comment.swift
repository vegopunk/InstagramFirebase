//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 03.11.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import Foundation

struct Comment {
    let text : String
    let uid : String
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? "" 
    }
}
