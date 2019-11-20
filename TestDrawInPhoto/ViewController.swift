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

    }

    @IBAction func cameraBtnPressed(_ sender: Any) {
        
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
