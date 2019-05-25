//
//  ViewController.swift
//  OnTheMap
//
//  Created by aziz on 19/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ActivityIndicator.stopAnimating()
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        
        ActivityIndicator.startAnimating()
        
        if checkEmpty() {
            alertFailure(message: StatusCodes.StatusCodes.emptyEmailOrPassword.rawValue)
        } else {
            Requests.Login(username: EmailTextField.text!, password: PasswordTextField.text!, completion: self.handleLoginResponse(flag:error:))
        }
    }
    
    func handleLoginResponse(flag: Bool, error: String?) {
        
        if flag {
            performSegue(withIdentifier: "LoginSuccessfull", sender: nil)
        } else {
            
            alertFailure(message: error!)
        }
    }
    
    func checkEmpty() -> Bool {
        
        if EmailTextField.text == "" || PasswordTextField.text == "" {
            return true
        }
        return false
    }
    
    func alertFailure(message: String) {
        
        ActivityIndicator.stopAnimating()
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert) in
            
        }))
        show(alertVC, sender: nil)
    }
}

