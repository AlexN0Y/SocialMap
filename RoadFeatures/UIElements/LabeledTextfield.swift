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
    
    @IBAction func textFieldChanged() {
        if let text = textField.text {
            onSave?(text)
        }
    }
    
    public func configureLabeledTextfield(labelText: String) {
        titleLabel.text = labelText
        self.backgroundColor = UIColor.secondarySystemBackground
        titleLabel.backgroundColor = UIColor.secondarySystemBackground
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

