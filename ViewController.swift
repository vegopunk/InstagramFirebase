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
        return button
    
    }()
    
    //поле ввода почты
    let emailTextField : UITextField = {
        let tf  = UITextField()
        tf.placeholder = "email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        return tf
    }()
    //поле ввода никнейма
    let usernameTextField : UITextField = {
        let tf  = UITextField()
        tf.placeholder = "username"
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
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //добавление кнопки на экран и его размещение auto layout
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        

        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //функция добавления полей ввода и кнопки в стаке
        setupInputFields()
        
            }


    fileprivate func setupInputFields() {
        
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
    
}

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor?,left:NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?,right:NSLayoutXAxisAnchor?, paddingTop: CGFloat , paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat,width: CGFloat,height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
        self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }

}



