//
//  LoginViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text{
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in if let e = error
            {
            self?.warningLabel.text = "Invalid email/password"
            print(e)
            
            
            }else{
                self?.navigationController?.popViewController(animated: true)
                }
            }
            }
        }
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        if (isValidEmail(emailID: emailTextfield.text ?? "")){
            Auth.auth().sendPasswordReset(withEmail: emailTextfield.text!) { error in
                if let error = error {
                    self.warningLabel.text = error.localizedDescription
                } else {
                    self.warningLabel.text = "Check your email to reset your password"
                }
            }
        }
        else{
            warningLabel.text = "Please enter a valid email"
        }
    }
    
    func isValidEmail(emailID:String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: emailID)
   }

}

