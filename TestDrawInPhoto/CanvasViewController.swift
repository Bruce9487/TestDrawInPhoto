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

    let canvasImageView: CanvasImageView = {
        let ui = CanvasImageView()
        ui.contentMode = .scaleAspectFit
        ui.layer.backgroundColor = UIColor.clear.cgColor
        ui.backgroundColor = UIColor.clear
        ui.clipsToBounds = true
        ui.isMultipleTouchEnabled = false
        ui.isUserInteractionEnabled = true
        return ui
    }()
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
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
        
        if #available(iOS 11.0, *) {
            self.canvasImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            self.canvasImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        }
        
        self.canvasImageView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
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
        
        UIGraphicsBeginImageContextWithOptions(self.canvasImageView.layer.bounds.size, true, 0.0)

        self.canvasImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let img = image {
            UIImageWriteToSavedPhotosAlbum(img, self,#selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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

    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 0.5) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        
        print("===) \(directory)")
        
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func drawOnImage(startingImage: UIImage) -> UIImage {
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(startingImage.size)
        
        // Draw the starting image in the current context as background
        startingImage.draw(at: CGPoint.zero)
        
        // Get the current context
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw a red line
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.red.cgColor)
        context.move(to: CGPoint(x: 100, y: 100))
        context.addLine(to: CGPoint(x: 200, y: 200))
        context.strokePath()
        
        // Draw a transparent green Circle
        context.setStrokeColor(UIColor.green.cgColor)
        context.setAlpha(0.5)
        context.setLineWidth(10.0)
        context.addEllipse(in: CGRect(x: 100, y: 100, width: 100, height: 100))
        context.drawPath(using: .stroke) // or .fillStroke if need filling
        
        // Save the context as a new UIImage
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return modified image
        return myImage!
    }
    
    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        guard let imageSize = imgSize else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y
        
        return imageRect
    }
    
}

extension UIImage {
    
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
