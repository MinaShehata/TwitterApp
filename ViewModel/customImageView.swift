//
//  customImageView.swift
//  WhatsApp
//
//  Created by Mina Shehata on 9/30/17.
//  Copyright © 2017 iShehata. All rights reserved.
//

import UIKit

// cache image after downloading from internet
let imageCashe = NSCache<NSURL , UIImage>()

// this class implement MVVM (Model View, View Model) Design Pattern
class customImageView: UIImageViewX {
    
    var imageUrl: URL?
    
    func loadProfileImageWithUrl(url: URL){
        
        image = nil
        
        imageUrl = url
        
        if let image = imageCashe.object(forKey: url as NSURL){
            self.image = image
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in // to break memory cycle
            do{
                let imageData = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let downloadesImage = UIImage(data: imageData), url == self?.imageUrl{
                        imageCashe.setObject(downloadesImage, forKey: url as NSURL)
                        self?.image = downloadesImage
                    }
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        
    }
}

