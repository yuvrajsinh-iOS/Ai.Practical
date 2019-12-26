//
//  UserCollectionviewCell.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import UIKit
import Kingfisher

class UserCollectionviewCell: UICollectionViewCell {

    // MARK: - IBOutlet -
    @IBOutlet private var imageView: UIImageView!

    // MARK: - Variables -
    var items:String!{
        didSet {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: items))
        }
    }

    // MARK: - Lifecycle Method -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
