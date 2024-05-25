//
//  NibLoadable.swift
//  RoadFeatures
//
//  Created by Alex Gav on 27.01.2024.
//

import UIKit

// MARK: - Requirements

protocol NibLoadable: AnyObject {
    
    static var nibName: String { get }
    static var reuseIdentifier: String { get }
}

// MARK: - Default Implementation

extension NibLoadable {
    
    static var nibName: String {
        String(describing: self)
    }
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

// MARK: - NibLoadable + UIViewController

extension NibLoadable where Self: UIViewController {
    
    static func instantiateFromNib() -> Self {
        let bundle = Bundle(for: self)
        return Self(nibName: nibName, bundle: bundle)
    }
}

