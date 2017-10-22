//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 22.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit
class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        print("Loading image...")
        
        lastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            //чек ошибки , затем загрузка картинки из базы
            if let err = err {
                print("Failed to fetch post image:" , err )
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            //проверка статуса (если 200 то все ОК)
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
