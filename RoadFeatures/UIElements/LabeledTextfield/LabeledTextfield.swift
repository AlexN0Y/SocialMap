//
//  LabeledTextfield.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.05.2023.
//

import UIKit

final class LabeledTextfield: UIView {
    
    // MARK: - Public Properties
    
    public var onSave: ((String) -> Void)?
    
    // MARK: - Private Properties
    
    @IBOutlet private var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet private var titleLabel: UILabel!
    private var textFieldType = TextFieldType.text
    
    // MARK: - Public Methods
    
    public func configureLabeledTextfield(
        labelText: String,
        textFieldType: TextFieldType = .text,
        keyboardType: UIKeyboardType = .default,
        placeholder: String
    ) {
        backgroundColor = UIColor.clear
        
        titleLabel.text = labelText
        
        textField.isSecureTextEntry = textFieldType == .password
        textField.keyboardType = keyboardType
        textField.placeholder = placeholder
        self.textFieldType = textFieldType
    }
    
    // MARK: - Private Methods
    
    @IBAction private func textFieldChanged() {
        guard let text = textField.text else { return }
        
        switch textFieldType {
        case .password:
            if isValidPassword(text) {
                onSave?(text)
                textField.layer.borderColor = UIColor(named: "accentBlue")!.cgColor
            } else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        case .email:
            if isValidEmail(text) {
                onSave?(text)
                textField.layer.borderColor = UIColor(named: "accentBlue")!.cgColor
            } else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        case .text:
            if text.count >= 3 {
                onSave?(text)
                textField.layer.borderColor = UIColor(named: "accentBlue")!.cgColor
            } else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}

// MARK: - UITextFieldDelegate

extension LabeledTextfield: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
