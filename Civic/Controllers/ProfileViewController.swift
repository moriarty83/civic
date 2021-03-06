//
//  ProfileViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/13/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import BTNavigationDropdownMenu

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
    
    
    override func viewWillAppear(_ animated: Bool) {
            loadMenu()
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

            let dataArray = [
                K.FStore.addressField : address,
                K.FStore.cityField : city,
                K.FStore.stateField: state,
                K.FStore.zipField: zip]
            
            db.collection("addresses").document(user).setData(dataArray)
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    @IBAction func didTapRemoveAddress(_ sender: UIButton) {
        if let user = Auth.auth().currentUser?.uid{
            db.collection("addresses").document(user).delete()
            userAddressLabel.text = "No Address Saved"
            NotificationCenter.default.post(name: Notification.Name("addressDeleted"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ProfileViewController{
    func loadMenu(){
        let menuView = BTNavigationDropdownMenu(title: "Profile", items: ["Home"])

        self.navigationItem.titleView = menuView
        menuView.menuTitleColor = UIColor(named: "ThemeWhite")
        menuView.cellTextLabelColor = UIColor(named: "ThemeWhite")
        menuView.cellBackgroundColor = UIColor(named: "ThemePurple")
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
