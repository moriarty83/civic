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

    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

//            db.collection("addresses").addDocument(data: dataArray) { error in
//                if let e = error{
//                    print("there was an issue saving data, \(e as NSError)")
//                }
//                else{
//                    print("successfully saved data")
//                    DispatchQueue.main.async {
//                        self.addressTextField.text = ""
//                        self.cityTextField.text = ""
//                        self.stateTextField.text = ""
//                        self.zipTextField.text = ""
//                    }
//                }
//            }
        }
    }
}
    


