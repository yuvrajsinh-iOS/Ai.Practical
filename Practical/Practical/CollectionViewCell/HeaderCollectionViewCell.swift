//
//  HeaderCollectionViewCell.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlet -
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var labelUsername: UILabel!

    // MARK: - Variables -
    var user:UserModel!{
        didSet {
            self.userImageView.kf.indicatorType = .activity
            self.userImageView.kf.setImage(with: URL(string: user.userImage))
            self.labelUsername.text = user.userName
        }
    }

    // MARK: - Lifecycle Method -
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    // MARK: - Custom Function -
    private func prepareView(){
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
    }
}
