//
//  ViewController.swift
//  movies-app
//
//  Created by Consultant on 3/23/22.
//

import UIKit

class ViewController: UIViewController {

    
    private let defaults = UserDefaults.standard
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write your name here."
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    // lazy var to get rid of warning? 'self' refers to the method 'ViewController.self', which may be unexpected
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc private func saveButtonAction() {
        if let name = nameTextField.text {
            if name.count > 2 {
                let moviesVC = MoviesViewController()
                moviesVC.modalPresentationStyle = .fullScreen
                self.defaults.set(name, forKey: Constants.defaultNameKey)
                
                let navController = UINavigationController(rootViewController: moviesVC)
                navController.modalPresentationStyle = .fullScreen
                
                self.present(navController, animated: true)
            } else {
                print("Name must be at least 3 characters long")
                // add warning text >= 3
            }
        }
    }
    
}

