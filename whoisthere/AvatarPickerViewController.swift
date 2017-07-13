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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ViewHelper.setCollectionViewLayout(collectionView: collectionView, margin: margin)
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
        
        cell.avatarImageView.image = UIImage(named: String(format: "%@%d", Constants.kAvatarImagePrefix, indexPath.item + 1))
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var userData =  UserData()
        userData.avatarId = indexPath.item + 1
        userData.save()
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
