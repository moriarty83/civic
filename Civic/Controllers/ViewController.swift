//
//  ViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var repsManager = RepsManager()
    
    weak var handle: AuthStateDidChangeListenerHandle?

    
    @IBOutlet weak var registerButton: UIButton!
    
    
    @IBAction func didTapRegister(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        vc.title = "Login"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if ((user) != nil) {
                print("User logged in")
                self?.registerButton.isHidden = true
              
            } else {
                print("Not Logged in")

                }
            
        }
        
        var repURL = "\(repsManager.baseURL)\(repsManager.key)&address=1263%20Pacific%20Ave.%20Kansas%20City%20KS"

        repsManager.performRequest(with: repURL)
    }
}

