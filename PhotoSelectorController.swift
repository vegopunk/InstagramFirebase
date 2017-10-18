//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 18.10.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit
import Photos


// UICollectionViewDelegateFlowLayout - для того чтобы указать размер ячейки
class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        setupNavigationButtons()
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        
        //чтобы первая фотография была большой
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        //добавляем фотографии
        fetchPhotos()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //определяем какую фотографию выбрали
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
    }
    
    var selectedImage : UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func assetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        //какое количество фотографий отображать
        fetchOptions.fetchLimit = 30
        
        //сортируем по дате с самых последних
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions())
        
        //подгружаем фотографии асинхронно
        DispatchQueue.global(qos: .background).async {
            
            
            allPhotos.enumerateObjects ({ (asset, count, stop) in
                print(asset)
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit , options: options, resultHandler: { (image, info) in
                    //добавляем в массив фотографий, который создан перед этой функцией
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        //чтобы при открытии выбора фотографии большая фотография показывала последнее фото
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        //перегружаем загруженные фотографии тоже асинхронно
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    
                })
            })
        }
        
        
    }
    
    // расстояние между большой фотографией и фотографиями ниже
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    //чтобы показывало изменившийся хедер надо задать размер
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    //для большой первой фотографии
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        //чтобы большая фотография изменялась на нажатую
        header.photoImageView.image = selectedImage
        
        if let selectedImage = selectedImage {
            if  let index = self.images.index(of: selectedImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    header.photoImageView.image = image
                })
            }
        }
        
        
        return header
    }
    
    //расстояние между ячейками по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //расстояние между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    //надо переопределять для количества ячеек
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    //переопределять для инициализации ячейки
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        //отображаем фотографии из массива через объект из photoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func handleNext() {
        print("Handling next")
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
