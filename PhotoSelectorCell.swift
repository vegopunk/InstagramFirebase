//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 18.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        //чтобы не косоебило фотографии при отображении
        iv.contentMode = .scaleAspectFill
        //чтобы фотографии не выходили за указанные рамки
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not be implemented")
    }
}
