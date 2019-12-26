//
//  UserModel.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import UIKit
import SwiftyJSON

//Mark:- User model
class UserModel: NSObject {
    var userName:String         = ""
    var userImage:String        = ""
    var userItem:[String]       = []

    required init(pareameter:JSON) {
        self.userName           = pareameter["name"].stringValue
        self.userImage          = pareameter["image"].stringValue
        self.userItem           = pareameter["items"].arrayObject as! [String]
    }
}
