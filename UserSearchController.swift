//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 26.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController : UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "cellId"
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        //изменение цвета внутри searchbar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        let navbar = navigationController?.navigationBar
        
        searchBar.anchor(top: navbar?.topAnchor, left: navbar?.leftAnchor, bottom: navbar?.bottomAnchor, right: navbar?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        //чтобы можно было прокурчивать список
        collectionView?.alwaysBounceVertical = true
        
        
        fetchUsers()
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers() {
        print("Fetching users...")
        
        let ref = FIRDatabase.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach({ (key,value) in
                
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            //сортируем по алфавиту
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch users for search: " , err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}
