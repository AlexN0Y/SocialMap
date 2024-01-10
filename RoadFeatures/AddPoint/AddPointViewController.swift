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

class AddPointViewController: UIViewController {
    
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
    
    @IBOutlet private weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.layer.borderWidth = 1.0
            descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private enum Constant {
        static let title = "Add Place"
    }
    
    private let locationManager = LocationManager()
    
    private let pointManager = PointManager.shared
    
    private var pickedImage: Point.Kind = Point.Kind.restaurant
    
    private var placeName: String?
    
    private let firebaseManager = FirebaseManager.shared
    
    // MARK: - Public Properties
    
    weak var delegate: AddPointViewControllerDelegate?
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let _ = firebaseManager.getCurrentUser() else {
            showNotAuthorisedAlert()
            return
        }
    }
    
    // MARK: - Private Methods
    
    @IBAction private func addButtonTapped() {
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            showNotAuthorisedAlert()
            return
        }
        
        guard let name = nameTextfield.text, !name.isEmpty else {
            showEmptyNameAlert()
            return
        }
        
        guard let location = locationManager.getCurrentLocationCoordinate() else {
            showNoLocationAlert()
            return
        }

        let city = isNilOrEmpty(string: cityTextfield.text)
        let description = descriptionTextView.text.isEmpty ? nil : descriptionTextView.text
        var point = Point(id: "Changable", name: name, description: description, city: city, kind: pickedImage, point: (location.latitude , location.longitude), owner: userId)
        pointManager.add(point: point) { error, documentID in
            if let error = error {
                print("Failed to add point:", error)
            } else if let documentID = documentID {
                point.id = documentID
                self.pointManager.addFavouritePointToUser(userID: userId, point: point) { error in
                    if let error = error {
                        print("Failed to add favourite point: \(error.localizedDescription)")
                    } else {
                    }
                }
                self.delegate?.pointWasAdded(pointID: documentID)
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
    
    private func showEmptyNameAlert() {
        let alert = UIAlertController(title: "Alert", message: "Fill in name field", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showNoLocationAlert() {
        let alert = UIAlertController(title: "Alert", message: "Cannot find your location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showNotAuthorisedAlert() {
        let alert = UIAlertController(title: "Alert", message: "Log in to add", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Point.Kind.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedKind = Point.Kind.allCases[row]
        pickedImage = selectedKind
    }
}

// MARK: - UIPickerViewDataSource

extension AddPointViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Point.Kind.allCases.count
    }
}

// MARK: - UITextFieldDelegate

extension AddPointViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

