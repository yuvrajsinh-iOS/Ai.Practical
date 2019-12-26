//
//  Constant.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import Foundation

let Web = AIWebservice.API

//Mark:- ReuseIdentifier for collectionview cell
enum ReuseIdentifier:String {

    case userCollectionviewCell
    case headerCollectionViewCell
    case footerCollectionViewCell

    var identifier:String {
        switch self {
        case .userCollectionviewCell:
            return "UserCollectionviewCell"
        case .headerCollectionViewCell:
            return "HeaderCollectionViewCell"
        case .footerCollectionViewCell:
            return "FooterCollectionViewCell"
        }
    }
}

