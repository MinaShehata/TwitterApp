//
//  customImageView.swift
//  WhatsApp
//
//  Created by Mina Shehata on 9/30/17.
//  Copyright © 2017 iShehata. All rights reserved.
//

import UIKit

// cache image after downloading from internet
let imageCashe = NSCache<NSString , UIImage>()
// this class implement MVVM (Model View, View Model) Design Pattern
class customImageView: UIImageViewX {
    var imageUrl: URL?

    func loadProfileImageWithUrl(url: String){
        image = nil
        
        guard let uRL = URL(string: url) else { return }
        imageUrl = uRL
        
        // from cache when network available.......
        if let image = imageCashe.object(forKey: url as NSString) {
            self.image = image
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in // to break memory cycle
            do{
                let imageData = try Data(contentsOf: uRL)
                DispatchQueue.main.async {
                    if let downloadesImage = UIImage(data: imageData), uRL == self?.imageUrl {
                        imageCashe.setObject(downloadesImage, forKey: url as NSString)
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

