//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 26.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID (uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            //            self.fetchPostsWithUser(user: user)
        }) { (err) in
            print("Failed to fetch user for posts:" , err)
        }
        
    }
}
