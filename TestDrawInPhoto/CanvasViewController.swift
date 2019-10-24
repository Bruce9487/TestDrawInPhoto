//
//  CanvasViewController.swift
//  TestDrawInPhoto
//
//  Created by APP技術部-陳冠志 on 2019/9/19.
//  Copyright © 2019 Bruce Chen. All rights reserved.
//

import UIKit
import SnapKit

class CanvasViewController: UIViewController {

    let imageView: UIImageView = {
        let ui = UIImageView()
        ui.contentMode = .scaleToFill
        return ui
    }()
    
    let canvasView: CanvasView = {
        let ui = CanvasView()
        ui.backgroundColor = UIColor.clear
        ui.clipsToBounds = true
        ui.isMultipleTouchEnabled = false
        ui.contentMode = .scaleAspectFill
        return ui
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "塗鴉區"
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnPressed(sender:)))
        let redo = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearBtnPressed(sender:)))
        let back = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelBtnPressed(sender:)))
        
        self.navigationItem.rightBarButtonItems = [save, redo]
        self.navigationItem.leftBarButtonItem = back
        
        self.setupView()
    }

    fileprivate func setupView() {
        
        self.view.addSubview(imageView)
        self.view.addSubview(canvasView)
        
        canvasView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
                
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(canvasView.snp.left)
            make.top.equalTo(canvasView.snp.top)
            make.right.equalTo(canvasView.snp.right)
            make.bottom.equalTo(canvasView.snp.bottom)
        }
        
    }

    //MARK: BUTTON ACTION
    
    @objc func cancelBtnPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func clearBtnPressed(sender: UIButton) {
        canvasView.clearCanvas()
    }

    @objc func saveBtnPressed(sender: UIButton) {
        
        let size = CGSize(width: self.imageView.bounds.width, height: self.imageView.bounds.height)
        
        let canvasImage: UIImage = self.canvasView.asImage()
        
        if let photoImage = self.imageView.image {
        
            //把兩個UIImage合再一起。參考：https://stackoverflow.com/a/32007118
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0) //讓照片畫質變好。 參考：https://stackoverflow.com/a/18030416
            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            photoImage.draw(in: areaSize)
            canvasImage.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(newImage, self,#selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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

