//
//  CanvasViewController.swift
//  TestDrawInPhoto
//
//  Created by APP技術部-陳冠志 on 2019/9/19.
//  Copyright © 2019 Bruce Chen. All rights reserved.
//

import UIKit
import SnapKit

enum ImageType {
    case horizontal //水平
    case vertical   //垂直
}

class CanvasViewController: UIViewController {
    
    let canvasImageView: CanvasImageView = {
        let ui = CanvasImageView()
        ui.contentMode = .scaleAspectFit
        ui.layer.backgroundColor = UIColor.clear.cgColor
        ui.backgroundColor = UIColor.clear
        ui.clipsToBounds = true
        ui.isMultipleTouchEnabled = false
        ui.isUserInteractionEnabled = true
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    //    var width: CGFloat = 0.0 {
    //        didSet {
    //            if width > 800 {
    //                width = 800
    //            }
    //        }
    //    }
    //
    //    var height: CGFloat = 0.0 {
    //        didSet {
    //            if height > 600 {
    //                height = 600
    //            }
    //        }
    //    }
    
    var imageType: ImageType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Color Yourself"
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnPressed(sender:)))
        let redo = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearBtnPressed(sender:)))
        let back = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelBtnPressed(sender:)))
        
        self.navigationItem.rightBarButtonItems = [save, redo]
        self.navigationItem.leftBarButtonItem = back
        
        self.setupView()
    }
    
    fileprivate func setupView() {
        
        self.view.addSubview(canvasImageView)
        
        if let imageType = self.imageType {
            
            self.canvasImageView.snp.makeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.centerY.equalToSuperview().offset(44)
            }
            
            switch imageType {
                
            case .horizontal:
                
                switch UIDevice.current.screenType {
                case .iPhones_4_4S, .iPhones_5_5s_5c_SE, .iPhones_6_6s_7_8, .iPhones_6Plus_6sPlus_7Plus_8Plus:
                    
                    self.canvasImageView.snp.makeConstraints { (make) in
                        make.height.equalToSuperview().multipliedBy(0.425)
                    }
                case .iPhones_X_XS, .iPhone_XR, .iPhone_XSMax:
                    
                    self.canvasImageView.snp.makeConstraints { (make) in
                        make.height.equalToSuperview().multipliedBy(0.3460625)
                    }
                case .unknown:
                    self.canvasImageView.snp.makeConstraints { (make) in
                        make.height.equalToSuperview().multipliedBy(0.56) // ipad
                    }
                    
                }
                
            case .vertical:
                
                switch UIDevice.current.screenType {
                case .iPhones_4_4S, .iPhones_5_5s_5c_SE, .iPhones_6_6s_7_8, .iPhones_6Plus_6sPlus_7Plus_8Plus:
                    
                    self.canvasImageView.snp.makeConstraints { (make) in
                        make.height.equalToSuperview().multipliedBy(0.75)
                    }
                case .iPhones_X_XS, .iPhone_XR, .iPhone_XSMax:
                    
                    self.canvasImageView.snp.makeConstraints { (make) in
                        make.height.equalToSuperview().multipliedBy(0.616)
                    }
                case .unknown:
                    self.canvasImageView.snp.makeConstraints { (make) in
                        make.height.equalToSuperview() // ipad
                    }
                    self.canvasImageView.snp.remakeConstraints { (make) in
                        make.centerY.equalToSuperview() // ipad
                    }
                    
                }
            }
            
        }
        
    }
    
    //MARK: BUTTON ACTION
    
    @objc func cancelBtnPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func clearBtnPressed(sender: UIButton) {
        canvasImageView.clearCanvas()
    }
    
    @objc func saveBtnPressed(sender: UIButton) {
        
        if let img = self.canvasImageView.screenShot, let imageType = self.imageType {
            
            switch imageType {
            case .horizontal:
                let finalImage = img.resizeImageBy(height: self.height)
                UIImageWriteToSavedPhotosAlbum(finalImage, self,#selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            case .vertical:
                let finalImage = img.resizeImageBy(width: self.width)
                UIImageWriteToSavedPhotosAlbum(finalImage, self,#selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        
    }
    
    //UIImage儲存到相簿成功與失敗。參考：https://www.hackingwithswift.com/example-code/media/uiimagewritetosavedphotosalbum-how-to-write-to-the-ios-photo-album
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "提醒", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "提醒", message: "儲存成功", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: false, completion: nil)
            }
            ac.addAction(okAction)
            present(ac, animated: true)
            
        }
    }
}
