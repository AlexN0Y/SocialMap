//
//  UICollectionView+Ext.swift
//  RoadFeatures
//
//  Created by Alex Gav on 27.01.2024.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell & NibLoadable>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView & NibLoadable>(
        _: T.Type, forSupplementaryViewOfKind kind: String
    ) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(
            nib, forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.reuseIdentifier
        )
    }
}
