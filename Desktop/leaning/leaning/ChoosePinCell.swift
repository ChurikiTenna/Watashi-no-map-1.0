//
//  collectionViewCell.swift
//  leaning
//
//  Created by Tenna on 2/5/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import UIKit

// CollectionViewのセル設定
class CollectionViewCell: UICollectionViewCell {
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContents(image: UIImage, textName: String) {
        cellImageView.image = image
        let pinheight = 40; let pinwidth = 30
        cellImageView.frame = CGRect(x: 25-pinwidth/2, y: 5, width: pinwidth, height: pinheight)
    }
}
