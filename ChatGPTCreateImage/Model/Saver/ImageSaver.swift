//
//  ImageSaver.swift
//  ChatGPTCreateImage
//
//  Created by cranoo3 on 2023/12/14.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) -> Bool {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
        return true
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("save finished")
    }
}
