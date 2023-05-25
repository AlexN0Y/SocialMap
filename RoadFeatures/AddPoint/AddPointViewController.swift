//
//  AddPointViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 22.05.2023.
//

import UIKit

protocol AddPointViewControllerDelegate: AnyObject {
    func pointWasAdded()
}

class AddPointViewController: UIViewController {
    weak var delegate: AddPointViewControllerDelegate?
    let locationManager = LocationManager()
    let pointManager = PointManager.shared
    var pickedImage: Point.Kind = Point.Kind.building
    var placeName: String?
    
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
    @IBOutlet private weak var kindPickerView: UIPickerView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kindPickerView.delegate = self
        kindPickerView.dataSource = self
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
    
    @IBAction private func addButtonTapped() {
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
        pointManager.add(name: name, description: description , city: city, kind: pickedImage, point: (location.latitude , location.longitude))
        delegate?.pointWasAdded()
    }
    
    private func isNilOrEmpty(string: String?) -> String? {
        guard let string = string, !string.isEmpty else {
            return nil
        }
        return string
    }
    
}

extension AddPointViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Point.Kind.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Point.Kind.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedKind = Point.Kind.allCases[row]
        pickedImage = selectedKind
    }
}

extension AddPointViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
