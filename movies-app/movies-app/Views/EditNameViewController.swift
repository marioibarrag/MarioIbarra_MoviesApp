//
//  EditNameViewController.swift
//  movies-app
//
//  Created by Consultant on 4/6/22.
//

import UIKit

protocol EditNameDelegate: AnyObject {
    func editName()
}

class EditNameViewController: UIViewController {
    weak var delegate: EditNameDelegate?
    
    private let newNameLabel: UILabel = {
        let label = UILabel()
        label.text = "New name:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write the new name here."
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(saveNewName), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUpUI() {
        view.addSubview(newNameLabel)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        
        newNameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -20).isActive = true
        newNameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        
    }

    @objc private func saveNewName() {
        if let name = nameTextField.text {
            if name.count > 2 {
                UserDefaults.standard.set(name, forKey: Constants.defaultNameKey)
                delegate?.editName()
                dismiss(animated: true)
                nameTextField.text = ""
            } else {
                print("Name must be at least 3 characters long")
                // add warning text >= 3
            }
        }
        // Add confirmation pop-up
        
//        dismiss(animated: true)
    }
    
}
