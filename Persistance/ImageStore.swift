//
//  imageStore.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

// this class handle image saving in database .........
class ImageStore{
    static let shared = ImageStore()
    private init() {}
    
    let cache = NSCache<NSString, UIImage>()
    
    func imageURL(forKey key: String) -> URL {
        
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        deleteImage(forKey: key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            let _ = try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            let exists = FileManager.default.fileExists(atPath: url.path)
            if exists {
                try FileManager.default.removeItem(at: url)
            }
        } catch let deleteError {
            print("Error when removing the image from disk: \(deleteError)")
        }
    }
}
