//
//  ViewController.swift
//  TestDrawInPhoto
//
//  Created by APP技術部-陳冠志 on 2019/9/18.
//  Copyright © 2019 Bruce Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("screenType:", UIDevice.current.screenType)

    }

    @IBAction func cameraBtnPressed(_ sender: Any) {

//        let vc = CanvasViewController()
//
//        if let path = Bundle.main.path(forResource: "IMG_0798", ofType: "JPG"), let image = UIImage(contentsOfFile: path) {
//            vc.canvasImageView.image = image
//            if image.size.width > image.size.height {
//                vc.imageType = .horizontal
//            } else {
//                vc.imageType = .vertical
//            }
//            self.present(UINavigationController(rootViewController: vc), animated: false, completion: nil)
//        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: false) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let vc = CanvasViewController()
                vc.canvasImageView.image = image
                vc.width = 2000
                vc.height = 2000
                if image.size.width > image.size.height {
                    vc.imageType = .horizontal
                } else {
                    vc.imageType = .vertical
                }
                self.present(UINavigationController(rootViewController: vc), animated: false, completion: nil)
            }
        
        }
        
    }
    
}
