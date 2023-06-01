//
//  LabeledTextfield.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.05.2023.
//

import UIKit

class LabeledTextfield: UIView, UITextFieldDelegate {
    
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    @IBOutlet private var titleLabel: UILabel!
    public var onSave: ((String) -> Void)?
    @IBAction private func textFieldChanged() {
        if let text = textField.text {
            onSave?(text)
        }
    }
    
    public func configureLabeledTextfield(labelText: String, secureTextEntry: Bool = false, keyboardType: UIKeyboardType = .default) {
        titleLabel.text = labelText
        self.backgroundColor = UIColor.secondarySystemBackground
        titleLabel.backgroundColor = UIColor.secondarySystemBackground
        textField.backgroundColor = UIColor.white
        textField.isSecureTextEntry = secureTextEntry
        textField.keyboardType = keyboardType
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

