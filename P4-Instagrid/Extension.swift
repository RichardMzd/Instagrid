//
//  Extension.swift
//  P4-Instagrid
//
//  Created by Richard Arif Mazid on 16/03/2022.
//

import Foundation
import UIKit


extension ViewController: UIImagePickerControllerDelegate {
    
// Methods to pick photos from library
    
    func showImagePickerController() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusButtons[indexButtons].setImage(image, for: .normal)
            plusButtons[indexButtons].imageView?.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


