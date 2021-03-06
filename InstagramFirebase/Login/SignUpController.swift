//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 30.05.17.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //кнопка добавления картинки на рег экране
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        //задание дефолтного изображения ???и чтобы оно оставалось исходного цвета????
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    
    }()
    
    func handlePlusPhoto () {
        let imagePickerController = UIImagePickerController ()
        
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["ImagePickerControllerOriginalImage" ] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        //делаем круглые края у кнопки загрузки фото
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        //рамка при загрузке фото
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
    //поле ввода почты
    let emailTextField : UITextField = {
        let tf  = UITextField()
        tf.placeholder = "email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    func handleTextInputChange () {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainBlue()
        }else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        }
    }
    
    //поле ввода никнейма
    let usernameTextField : UITextField = {
        let tf  = UITextField()
        tf.placeholder = "username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    //поле ввода пароля
    let passwordTextField : UITextField = {
        let tf  = UITextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    
    
    //кнопка подтверждения регистрации
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        
        button.backgroundColor = UIColor.rgb(red: 149,green: 204,blue: 244)
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    func handleSignUp() {
        
        guard let email = emailTextField.text , email.count > 0 else {return}
        guard let username = usernameTextField.text , username.count > 0 else {return}
        guard let password = passwordTextField.text , password.count > 0 else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (User, Error) in
            if let err = Error {
                print("failedto create user" , err )
            }
            print("successtully create user: ",User?.uid ?? "")
            
            guard let image = self.plusPhotoButton.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(fileName).putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image:" , err)
                    return
                }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {return}
                print("Successfully uploaded profile image" , profileImageUrl)
                
                guard let uid = User?.uid else {return}
                
                let dictionaryValues = ["username" : username , "profileImageURl" : profileImageUrl]
                let values = [uid:dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("failed to save user info into db" , err)
                    }
                    print("Successfully saved user info to db")
                    //после удачной регистрации переходим на контроллер профиля
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    
                    mainTabBarController.setupViewControllers()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
            })
        }
    }
        
    
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14) , NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        //добавление кнопки на экран и его размещение auto layout
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //функция добавления полей ввода и кнопки в стаке
        setupInputFields()
        
        }


    func setupInputFields() {
        
        let redView = UIView()
        redView.backgroundColor = .red
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField , usernameTextField, passwordTextField , signUpButton])
        
        //равномерное распределение полей
        stackView.distribution = .fillEqually
        //чтобы стак полей вертикальным, а не горизонтальным
        stackView.axis = .vertical
        //расстояние между полями
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        //активация изменений в массиве
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
    }
    

    func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
}




