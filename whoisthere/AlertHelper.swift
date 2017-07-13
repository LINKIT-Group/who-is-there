//
//  File.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright © 2017 Efe Kocabas. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    class func warn(delegate: UIViewController, message: String) {
        
        let alert = UIAlertController(title: "_alert_title".localized, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "_alert_ok".localized, style: UIAlertActionStyle.default, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
    }
    
}
