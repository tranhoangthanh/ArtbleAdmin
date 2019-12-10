//
//  Extension.swift
//  Artable
//
//  Created by Trần Thành on 12/4/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    func simpleAlert(title : String , msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
         alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}



