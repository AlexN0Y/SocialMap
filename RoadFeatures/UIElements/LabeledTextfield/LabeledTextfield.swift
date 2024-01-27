//
//  LabeledTextfield.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.05.2023.
//

import UIKit

class LabeledTextfield: UIView {
    
    // MARK: - Public Properties
    
    public var onSave: ((String) -> Void)?
    
    // MARK: - Private Properties
    
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet private var titleLabel: UILabel!
    
    @IBAction private func textFieldChanged() {
        if let text = textField.text {
            onSave?(text)
        }
    }
    
    // MARK: - Public Methods
    
    public func configureLabeledTextfield(
        labelText: String,
        secureTextEntry: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.backgroundColor = UIColor.clear
        
        titleLabel.text = labelText
        
        textField.isSecureTextEntry = secureTextEntry
        textField.keyboardType = keyboardType
    }
}

// MARK: - UITextFieldDelegate

extension LabeledTextfield: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
