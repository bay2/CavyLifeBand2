//
//  DetailTimeBucketLayout.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class DetailTimeBucketLayout: UICollectionViewFlowLayout {

    let timeButtonWidth = ez.screenWidth / 3
    
    
    override func prepareLayout() {
        
        self.itemSize = CGSizeMake(timeButtonWidth, 50)
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = 0
        let inset = ez.screenWidth  * 0.5 - timeButtonWidth * 0.5
        self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
    }
    
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        
        
        let array: Array<UICollectionViewLayoutAttributes> = super.layoutAttributesForElementsInRect(rect)!
        
        let centerX = ez.screenWidth * 0.5 + self.collectionView!.contentOffset.x
        for attrs in array {
            
            Log.info("\(attrs.representedElementCategory)\(attrs.indexPath.row)")
            
            

            
        }
        
        
        return array
    }
    
}
