//
//  CostomLayout.swift
//  Project25
//
//  Created by adrians.freimanis on 03/08/2023.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    override func prepare() {
            super.prepare()
            guard let collectionView = collectionView else { return }
            
            let numberOfItemsPerRow: CGFloat = 3 // You can adjust this value to change the number of items per row
            let spacing: CGFloat = 10
            
            let totalSpacing = (numberOfItemsPerRow - 1) * spacing
            let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
            
            self.itemSize = CGSize(width: itemWidth, height: itemWidth)
            self.minimumInteritemSpacing = spacing
            self.minimumLineSpacing = spacing
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
                return nil
            }
            
            if indexPath.item % 3 == 0 {
                // First item in each row
                attributes.frame.origin.x = sectionInset.left
            } else {
                // Not the first item in each row
                let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                if let previousAttributes = layoutAttributesForItem(at: previousIndexPath) {
                    attributes.frame.origin.x = previousAttributes.frame.maxX + minimumInteritemSpacing
                }
            }
            
            return attributes
        }
}
