//
//  LoginViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func loginButtonTapped() {
        if let email = loginView.emailTextField.text, let password = loginView.passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showLoginFailedAlert(error: e.localizedDescription)
                    print(e)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc func registerButtonTapped() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    private func showLoginFailedAlert(error: String) {
        let alert = UIAlertController(title: "Login failed", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
