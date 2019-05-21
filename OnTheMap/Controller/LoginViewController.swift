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
    
    @IBAction func SignUpPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func LogInPressed(_ sender: Any) {
        
        ActivityIndicator.startAnimating()
        
        Requests.Login(username: EmailTextField.text ?? "", password: PasswordTextField.text ?? "", completion: self.handleLoginResponse(flag:))
    }
    
    func handleLoginResponse(flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "LoginSuccessfull", sender: nil)
        } else {
            //alert
            //empty fields or invalid
        }
    }
    
}

