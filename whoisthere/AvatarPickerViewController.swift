//
//  AvatarPickerViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright (c) 2017 Efe Kocabas. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    let reuseIdentifier = "AvatarPickerCell"
    let columnCount = 3
    let margin : CGFloat = 10
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        flowLayout.estimatedItemSize = flowLayout.itemSize // CGSize(width: 50, height: 50)
        
        
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(columnCount - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(columnCount)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    // make a cell for each cell index path
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AvatarPickerCell
        
        cell.avatarImageView.image = UIImage(named: String(format: "avatar%d", indexPath.item + 1))
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let defaults = UserDefaults.standard
        defaults.set(indexPath.item + 1, forKey: UserDataKeys.avatarId)
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
