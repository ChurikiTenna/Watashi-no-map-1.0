//
//  CollectionViewHeader.swift
//  leaning
//
//  Created by Tenna on 2/27/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import UIKit

// CollectionViewのヘッダー設定
class CollectionViewHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 10))
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpViews() {
        backgroundColor = UIColor(red: 236/255, green: 232/255, blue: 232/255, alpha: 1.0)
        
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setUpContents(titleText: String) {
        titleLabel.text = titleText
    }
}
