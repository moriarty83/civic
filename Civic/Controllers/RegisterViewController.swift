//
//  RegisterViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase
import BTNavigationDropdownMenu

class RegisterViewController: UIViewController {

    @IBOutlet weak var warning: UILabel!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
            loadMenu()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        
        if(!isValidEmail(emailID: emailTextfield.text ?? "")){
            warning.text = "Please enter a valid email"
            return
        }
        
        
        if let email = emailTextfield.text, let password = passwordTextfield.text, let confirm = confirmPwdTextField.text{
            
        if(password != confirm){
            warning.text = "Passwords do not match"
            return
        }
            
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error{
                // Add to label item so people can see the error.
                self.warning.text = e.localizedDescription
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
                vc.title = "Profile"
                vc.addressString = ""
                self.navigationController?.pushViewController(vc, animated: true)}
            }
        }
        
    }
    
    func isValidEmail(emailID:String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: emailID)
   }
}

extension RegisterViewController{
    func loadMenu(){
        let menuView = BTNavigationDropdownMenu(title: "Register", items: ["Home"])

        self.navigationItem.titleView = menuView
        menuView.menuTitleColor = UIColor(named: "ThemeWhite")
        menuView.cellTextLabelColor = UIColor(named: "ThemeWhite")
        menuView.cellBackgroundColor = UIColor(named: "ThemePurple")
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
