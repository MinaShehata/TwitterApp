//
//  ProfileLayout.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/6/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class ProfileLayout: UICollectionViewFlowLayout {

    var hideBackButton:CGFloat = 1
    // create stretched header when user scroll we add to image height delta height ///
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        let offset = collectionView!.contentOffset
        if (offset.y < 0) {
            let deltaHeight = fabs(offset.y)
            for attribute in layoutAttributes! {
                if let elementKind = attribute.representedElementKind, elementKind == UICollectionElementKindSectionHeader {
                    var frame = attribute.frame
                    frame.size.height = max(0, headerReferenceSize.height + deltaHeight)
                    frame.origin.y = frame.minY - deltaHeight
                    attribute.frame = frame
                }
            }
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
