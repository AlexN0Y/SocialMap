//
//  AddPointViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 22.05.2023.
//

import UIKit

// MARK: - AddPointViewControllerDelegate

protocol AddPointViewControllerDelegate: AnyObject {
    
    func pointWasAdded(pointID: String)
}

final class AddPointViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var nameTextfield: UITextField! {
        didSet {
            nameTextfield.delegate = self
        }
    }
    
    @IBOutlet private weak var cityTextfield: UITextField! {
        didSet {
            cityTextfield.delegate = self
        }
    }
    
    @IBOutlet private weak var kindPickerView: UIPickerView! {
        didSet {
            kindPickerView.delegate = self
            kindPickerView.dataSource = self
        }
    }
    
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    private enum Constant {
        
        static let title = String(localized: "Add Place")
    }
    
    private let locationManager = LocationManager()
    private let pointManager = PointManager.shared
    private var pickedKind: Point.Kind = Point.Kind.restaurant
    private var placeName: String?
    private let firebaseManager = FirebaseManager.shared
    
    // MARK: - Public Properties
    
    weak var delegate: AddPointViewControllerDelegate?
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.title
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    
    @IBAction private func addButtonTapped() {
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            showNotAuthorisedAlert()
            return
        }
        
        guard let name = nameTextfield.text, name.count > 3 else {
            presentAlert(message:String(localized: "Fill in name field"))
            return
        }
        
        guard let location = locationManager.getCurrentLocationCoordinate() else {
            presentAlert(message: String(localized: "Cannot find your location"))
            return
        }

        let city = isNilOrEmpty(string: cityTextfield.text)
        let description = descriptionTextView.text.isEmpty ? nil : descriptionTextView.text
        var point = Point(
            id: "Changable",
            name: name, description: description,
            city: city, kind: pickedKind,
            point: (location.latitude , location.longitude),
            owner: userId
        )
        
        // check the logic, maybe i can add custom documentid
        pointManager.add(point: point) { [weak self] error, documentID in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Failed to add point:", error)
            } else if let documentID {
                point.id = documentID
                pointManager.addFavouritePointToUser(userID: userId, point: point) { error in
                    guard let error else { return }
                    
                    HUD.present(type: .error(String(localized: "Error occured")))
                    print("Failed to add favourite point: \(error.localizedDescription)")
                }
                
                delegate?.pointWasAdded(pointID: documentID)
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    @objc 
    private func handleTap() {
        view.endEditing(true)
    }
    
    private func showNotAuthorisedAlert() {
        presentAlert(message: String(localized: "Log in to add")) { [weak self] in
            guard let self else { return }
        
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func presentAlert(
        message: String,
        onTapOK: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: String(localized: "Alert"),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            onTapOK?()
        })
        
        present(alert, animated: true)
    }
    
    private func isNilOrEmpty(string: String?) -> String? {
        guard let string = string, !string.isEmpty else {
            return nil
        }
        
        return string
    }
}

// MARK: - UIPickerViewDelegate

extension AddPointViewController: UIPickerViewDelegate {
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        Point.Kind.allCases[row].title
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int, 
        inComponent component: Int
    ) {
        let selectedKind = Point.Kind.allCases[row]
        pickedKind = selectedKind
    }
}

// MARK: - UIPickerViewDataSource

extension AddPointViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        Point.Kind.allCases.count
    }
}

// MARK: - UITextFieldDelegate

extension AddPointViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

