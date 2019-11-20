//
//  Extensions.swift
//  TestDrawInPhoto
//
//  Created by APP技術部-陳冠志 on 2019/10/31.
//  Copyright © 2019 Bruce Chen. All rights reserved.
//

import UIKit

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    /**
     重設圖片大小
     */
    func reSizeImage(size: CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize)
        UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage!
    }
    
    /**
     等比例縮放
     */
    func scaleImage(scaleSize: CGFloat) -> UIImage {
        
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(size: reSize)
    }

}




