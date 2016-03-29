//
//  PapersFlowLayout.swift
//  Papers
//
//  Created by Ugo Besa on 25/03/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PapersFlowLayout: UICollectionViewFlowLayout {
    
    var appearingItemIndexPath: NSIndexPath?
    var disappearingItemIndexPaths: [NSIndexPath]?
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if let indexPath = appearingItemIndexPath {
            if let attributes = attributes {
                if indexPath == itemIndexPath {
                    //let width = CGRectGetWidth(collectionView!.frame)
                    attributes.alpha = 1.0
                    attributes.center = CGPoint(x: CGRectGetWidth(collectionView!.frame) - 23.5, y: -24.5)
                    attributes.transform = CGAffineTransformMakeScale(0.15, 0.15)
                    attributes.zIndex = 99
                }
            }
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        if let indexPaths = disappearingItemIndexPaths {
            if let attributes = attributes {
                if indexPaths.contains(itemIndexPath) {
                    attributes.alpha = 1.0
                    attributes.transform = CGAffineTransformMakeScale(0.1, 0.1)
                    attributes.zIndex = -1
                }
            }
        }
        return attributes
    }
    
}
