//
//  AuthViewController.swift
//  ProfileSettings
//
//  Created by Кирилл Сысоев on 11.05.2025.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc func signUpButtonTapped() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    let alert = UIAlertController(title: "Ошибка!", message: "Такой пользователь уже существует.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Oк", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                } else {
                    db.child("users").child("user-\(Auth.auth().currentUser!.uid)").setValue([
                        "email": email,
                        "password": password
                    ])
                }
            }
        }
    }
    
    @objc func signInButtonTapped() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    let alert = UIAlertController(title: "Ошибка!", message: "Такого пользователя не существует.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Oк", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }

}
