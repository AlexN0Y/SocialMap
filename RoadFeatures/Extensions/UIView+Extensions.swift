//
//  UIView+Extensions.swift
//  RoadFeatures
//
//  Created by Alex Gav on 12.05.2023.
//

import UIKit

public extension UIView {
    
    static func fromNib<T: UIView>() -> T {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: String(describing: T.self), bundle: bundle)
        return nib.instantiate(withOwner: T.self).first as! T
    }
}
