//
//  TagViewFlowLayout.swift
//  SampleJect
//
//  Created by Sin's Retina on 2018. 8. 9..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class TagViewFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: UICollectionViewDelegateFlowLayout?
    
    /// vertical스크롤 일 때 왼쪽 정렬
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let array = super.layoutAttributesForElements(in: rect) else { return nil }
        switch scrollDirection {
        case .vertical:     // 왼쪽 정렬 로직
            for (index, attr) in array.enumerated() {
                var itemSpacing: CGFloat = 0
                var contentsInsets = UIEdgeInsets.zero
                
                if let del = delegate {
                    itemSpacing = del.collectionView!(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: attr.indexPath.section)
                    contentsInsets = del.collectionView!(self.collectionView!, layout: self, insetForSectionAt: attr.indexPath.section)
                }
                
                if attr.indexPath.item != 0, let prevAttr = layoutAttributesForItem(at: IndexPath(item: attr.indexPath.item - 1, section: attr.indexPath.section)) {
                    var prevLineRect = prevAttr.frame
                    prevLineRect.size.width = collectionViewContentSize.width - contentsInsets.left - contentsInsets.right
                    
                    // FlowLayout버그로 인한 오차범위 교정
                    var lineCheckFrame = attr.frame
                    lineCheckFrame.origin.y += 0.5
                    
                    if !prevLineRect.intersects(lineCheckFrame) {
                        attr.frame.origin.x = contentsInsets.left
                    } else {
                        if index == 0 {
                            attr.frame.origin.x = prevAttr.frame.maxX + itemSpacing
                        } else {
                            attr.frame.origin.x = array[index - 1].frame.maxX + itemSpacing
                        }
                    }
                } else {
                    attr.frame.origin.x = contentsInsets.left
                }
            }
        default:
            return array
        }
        
        return array
    }
}
