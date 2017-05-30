//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 30.05.17.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //кнопка добавления картинки на рег экране
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        //задание дефолтного изображения ???и чтобы оно оставалось исходного цвета????
        button.setImage(#imageLiteral(resourceName: "reg_addPhoto").withRenderingMode(.alwaysOriginal), for: .normal)
        //чтобы можно было задавать изменения
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    
    }()
    
    //поле ввода почты
    let emailTextField : UITextField = {
        let tf  = UITextField()
        tf.placeholder = "email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        return tf
    }()
    //поле ввода никнейма
    let usernameTextField : UITextField = {
        let tf  = UITextField()
        tf.placeholder = "username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        return tf
    }()
    //поле ввода пароля
    let passwordTextField : UITextField = {
        let tf  = UITextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    //кнопка подтверждения регистрации
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //добавление кнопки на экран и его размещение auto layout
        view.addSubview(plusPhotoButton)
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        //функция добавления полей ввода и кнопки в стаке
        setupInputFields()
        
            }


    fileprivate func setupInputFields() {
        
        let redView = UIView()
        redView.backgroundColor = .red
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField , usernameTextField, passwordTextField , signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //равномерное распределение полей
        stackView.distribution = .fillEqually
        //чтобы стак полей вертикальным, а не горизонтальным
        stackView.axis = .vertical
        //расстояние между полями
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        //активация изменений в массиве
        NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
        stackView.heightAnchor.constraint(equalToConstant: 200)])

    }
    
}

