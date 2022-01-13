//
//  RegisterViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var warning: UILabel!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBAction func registerPressed(_ sender: UIButton) {
        
        
        
        if let email = emailTextfield.text, let password = passwordTextfield.text, let confirm = confirmPwdTextField.text{
            
            if(password != confirm){
                warning.text = "Passwords do not match"
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    // Add to label item so people can see the error.
                    print(e.localizedDescription)
                }
                else{
                    
                }
            }
        }
    }
}
