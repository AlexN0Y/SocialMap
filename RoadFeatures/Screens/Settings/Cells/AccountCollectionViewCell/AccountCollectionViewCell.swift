//
//  AccountCollectionViewCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 20.01.2024.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    var onTapRegistration: (() -> Void)?
    var onTapLogIn: (() -> Void)?
    
    @IBOutlet private weak var containerView: UIView!
    
    private var embeddedViewController: AccountLogInViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
    }
    
    private func configureContainerView() {
        let viewController = AccountLogInViewController.instantiateFromNib()
        
        viewController.onTapLogIn = { [weak self] in
            self?.onTapLogIn?()
        }
        viewController.onTapRegistration = { [weak self] in
            self?.onTapRegistration?()
        }
        
        embedViewController(viewController)
    }
    
    
    private func embedViewController(_ viewController: AccountLogInViewController) {
        self.embeddedViewController = viewController
        
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParent: parentViewController)
    }
    
    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
