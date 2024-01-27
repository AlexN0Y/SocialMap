//
//  UIViewController+Extension.swift
//  RoadFeatures
//
//  Created by Alex Gav on 24.04.2023.
//

import UIKit

extension UIViewController {
    
    class func instantiate<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
