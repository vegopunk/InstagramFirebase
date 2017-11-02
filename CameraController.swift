//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Денис Попов on 01.11.2017.
//  Copyright © 2017 Денис Попов. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    func handleCapturePhoto(){
        print("capturing photo...")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
    }
    
    fileprivate func setupHUD() {
        
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //setup inputs
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input: " , err)
        }
        //setup outputs
        let output = AVCapturePhotoOutput()
        captureSession.addOutput(output)
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //setup output preview
        guard let previewLayer  = AVCaptureVideoPreviewLayer(session: captureSession) else {return}
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}
