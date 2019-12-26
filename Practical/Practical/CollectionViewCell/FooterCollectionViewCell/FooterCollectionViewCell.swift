//
//  FooterCollectionViewCell.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import UIKit

class FooterCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet -
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle Method -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicator.startAnimating()
    }
}
