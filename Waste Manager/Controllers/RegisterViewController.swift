//
//  RegisterViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(registerView)
        
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.topAnchor),
            registerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            registerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func registerButtonTapped() {
        if let email = registerView.emailTextField.text, let password = registerView.passwordTextField.text, let confirmPassword = registerView.confirmPasswordTextField.text {
            if password == confirmPassword {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        self.showRegistrationFailedAlert(error: e.localizedDescription)
                        print(e.localizedDescription)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                showRegistrationFailedAlert(error: "Please Check Password and ConfirmPassword Again")
            }
        } else {
        }
    }
    
    private func showRegistrationFailedAlert(error: String) {
        let alert = UIAlertController(title: "Registration failed", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

