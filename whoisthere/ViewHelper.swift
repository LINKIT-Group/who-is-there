//
//  ViewHelper.swift
//  whoisthere
//
//  Created by Efe Kocabas on 13/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper {
    
    class func setCollectionViewLayout(collectionView: UICollectionView?, margin: CGFloat) {
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        flowLayout.estimatedItemSize = flowLayout.itemSize
    }
    
}
