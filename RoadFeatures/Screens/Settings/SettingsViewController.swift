//
//  SettingsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class SettingsViewController: UIViewController, NibLoadable {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let settingsItems = Settings.allCases
    private let firebaseManager = FirebaseManager.shared
    
    private enum Constant {
        static let title = "Settings"
        static let logInStoryboardName = "LogIn"
        static let logInViewControllerName = "LoginViewController"
    }
    
    private var isGuest: Bool {
        firebaseManager.getCurrentUser() == nil
    }
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - Private Properties
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(AccountCollectionViewCell.self)
        collectionView.register(SettingsCollectionViewCell.self)
    }
    
    private func onTapLogIn() {
        let logInStoryboard = UIStoryboard(name: Constant.logInStoryboardName, bundle: nil)
        let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: Constant.logInViewControllerName) as! LoginViewController
        logInViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    private func onTapRegistration() {
        
    }
}

extension SettingsViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        settingsItems.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row == 0 && isGuest {
            let cell: AccountCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountCollectionViewCell.self), for: indexPath) as! AccountCollectionViewCell
            
            cell.onTapLogIn = { [weak self] in
                self?.onTapLogIn()
            }
            cell.onTapRegistration = { [weak self] in
                self?.onTapRegistration()
            }
            
            return cell
        } else {
            let cell: SettingsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SettingsCollectionViewCell.self), for: indexPath) as! SettingsCollectionViewCell
            
            cell.configure(for: settingsItems[indexPath.row])
            cell.delegate = self

            return cell
        }
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.row {
        case 0:
            if !isGuest {
                let viewController = ProfileViewController.instantiateFromNib()
                navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            return
        }
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height: CGFloat = (isGuest && indexPath.row == 0) ? 312 : 56
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}

extension SettingsViewController: SettingsCellDelegate {
    
    func didToggleThemeSwitch() {
        guard let windowScene = view.window?.windowScene else { return }
        
        var isDarkModeEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKey.isDarkModeEnabled.rawValue)
        isDarkModeEnabled.toggle()
        UserDefaults.standard.set(isDarkModeEnabled, forKey: UserDefaultsKey.isDarkModeEnabled.rawValue)
        
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
    }
}
