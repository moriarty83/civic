//
//  ProfileViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/13/22.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {
    let db = Firestore.firestore()
    
    var addressString = ""

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    
    @IBOutlet weak var userAddressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAddressLabel.text = addressString.replacingOccurrences(of: "%20", with: " ")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapUpdate(_ sender: Any) {
        if(addressTextField.text == ""){
            return
        }
        
        if let user = Auth.auth().currentUser?.uid,
            let address = addressTextField.text,
            let city = cityTextField.text,
            let state = stateTextField.text,
            let zip = zipTextField.text{

            print("making db req")
            let dataArray = [
                K.FStore.addressField : address,
                K.FStore.cityField : city,
                K.FStore.stateField: state,
                K.FStore.zipField: zip]
            
            db.collection("addresses").document(user).setData(dataArray)
            print (dataArray)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    @IBAction func didTapRemoveAddress(_ sender: UIButton) {
        if let user = Auth.auth().currentUser?.uid{
            db.collection("addresses").document(user).delete()
            userAddressLabel.text = "No Address Saved"
            self.navigationController?.popViewController(animated: true)
        }
    }
}
    


