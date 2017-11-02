//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 02.11.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        
        collectionView?.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = . white
        containerView.frame = CGRect(x: 0, y: 0, width:  100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Send", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14 )
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0 )
        
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Comment"
        return tf
    }()
    
    func handleSubmit() {
        guard let uid = FIRAuth.auth()?.currentUser else {return}
        print("PostId: ", self.post?.id ?? "")
        print("Inserting comment: " , commentTextField.text ?? "" )
        
        let postId = self.post?.id ?? ""
        let values = ["text" : commentTextField.text ?? "" , "creationDate" : Date().timeIntervalSince1970 , "uid" : uid ] as [String : Any]
        FIRDatabase.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment: " , err)
                return
            }
            print("Successfully inserted comment in database")
        }
    }
    
    //для места  ввода комментария
    override var inputAccessoryView: UIView? {
        get{
            return containerView
        }
    }
    // обязательно для inputAccessoryView
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
