//
//  LineLayout.swift
//  collectionSwift
//
//  Created by DEMO on 16/4/11.
//  Copyright © 2016年 DEMO. All rights reserved.
//

import UIKit

class LineLayout: UICollectionViewFlowLayout {

    let itemSizeWidth: CGFloat = 50.0
    
    let zoomScale: CGFloat = 0.4
    
    let horizontalInset: CGFloat = 0.0
    
    let verticalInset: CGFloat = 0.0
    
    let activeDistance: CGFloat = 120.0
    
    override init() {
        super.init()
        
        self.itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth)
        
        self.scrollDirection = .Horizontal
        
        self.sectionInset = UIEdgeInsetsMake(verticalInset, horizontalInset,
                                             verticalInset, horizontalInset)
        
        self.minimumLineSpacing = 30.0
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElementsInRect(rect)
        
        //collection可视区域
        let visibleRect = CGRect(origin: (self.collectionView?.contentOffset)!,
                                 size: (self.collectionView!.bounds.size))
        
        for attribute: UICollectionViewLayoutAttributes in array! {
            
            //对在可视区域的cell做缩放
            if CGRectIntersectsRect(attribute.frame, visibleRect) {
                
                let distance: CGFloat = CGRectGetMidX(visibleRect) - attribute.center.x
                
                let normalizedDistance: CGFloat = distance / activeDistance
                
                
                if fabs(distance) <= activeDistance {
                    let zoom: CGFloat = 1 + zoomScale * (1 - fabs(normalizedDistance))
                    
                    attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    
                    attribute.zIndex = 1
                    
                    attribute.alpha = zoom - 0.7
                    
                }
            }
        }
        
        return array
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var offsetAdjustment: CGFloat = CGFloat(MAXFLOAT)
        
        let horizontalCenter: CGFloat = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0)
        
        let targetRect: CGRect = CGRect(x: proposedContentOffset.x, y: 0.0,
                                        width: self.collectionView!.bounds.size.width,
                                        height: self.collectionView!.bounds.size.height)
        
        let array = super.layoutAttributesForElementsInRect(targetRect)
        
        for attribute: UICollectionViewLayoutAttributes in array! {
            
            let itemHorizontalCenter: CGFloat = attribute.center.x
            
            if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjustment) {
                
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
                
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
  
}
