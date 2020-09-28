//
//  LoginController.swift
//  On the Map
//
//  Created by Diego on 23/09/2020.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var backgroundEmail: UIStackView!
    @IBOutlet weak var backgroudPassword: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtom: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundEmail.addBackground(color: .systemGray6)
        backgroudPassword.addBackground(color: .systemGray6)
    }
    
    
    @IBAction func loginButtom(_ sender: Any) {
        guard let email = emailTextField.text, emailTextField.hasText else{
            showFailure(message: "Please enter a valid email")
            return
        }
        guard let password = passwordTextField.text, passwordTextField.hasText else {
            showFailure(message: "Please enter a password")
            return
        }
        setLoggingIn(true)
        Client.login(username: email, password: password, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func registerButton(_ sender: Any) {
        UIApplication.shared.open(Client.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
            
        } else {
            self.showFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
        }
    }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButtom.isEnabled = !loggingIn
        loginButtom.alpha = loggingIn ? 0.5 : 1.0
        registerButton.isEnabled = !loggingIn
        registerButton.alpha = loggingIn ? 0.5 : 1.0
    }
    
}


