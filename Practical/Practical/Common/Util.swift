//
//  Util.swift
//  Practical
//
//  Created by MAC103 on 26/12/19.
//  Copyright © 2019 MAC103. All rights reserved.
//

import Foundation
import UIKit


class Util:NSObject {

    //MARK:- Check internet connection
    class var isReachable:Bool {
        return Reachability.shared.connection != .none
    }

    //MARK:- Custom alertview
    class func showAlet(message:String,view:UIViewController) {
        let alert       = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okAction    = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        view.present(alert, animated: true, completion: nil)
    }
}
