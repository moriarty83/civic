//
//  ViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import BTNavigationDropdownMenu

class ViewController: UIViewController {
    
    let testArray = ["tom", "dick", "harry"]
    
    let indexCount = 0
    
    let db = Firestore.firestore()
    
    var addressString: String = ""
    
    var repsManager = RepsManager()
    
    weak var handle: AuthStateDidChangeListenerHandle?
    
    var loggedIn = false

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var guestButton: UIButton!
    
    @IBAction func didTapRegister(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
        
        
    }
    @IBAction func didTapLogin(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        vc.title = "Login"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repsManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // Nav Menu
        let menuView = BTNavigationDropdownMenu(title: "Menu", items: testArray)
        self.navigationItem.titleView = menuView
        menuView.cellBackgroundColor = UIColor(named: "ThemePurple")
        
        var repURL = "\(repsManager.baseURL)\(repsManager.key)&address=\(addressString)"

        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if ((user) != nil) {
                
                self?.loggedIn = true

                self?.registerButton.isHidden = true
                self?.guestButton.isHidden = true
                
                self?.db.collection("addresses").document(user!.uid)
                    .addSnapshotListener { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                      }
                      guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                      }
                        var string = ""
                        for (key, value) in data{
                            string = "\(string) \(value)"
                        }
                        self?.addressString = string.replacingOccurrences(of: " ", with: "%20")
                        repURL = "\(self!.repsManager.baseURL)\(self!.repsManager.key)&address=\(self!.addressString)"
                        print(repURL)
                        self!.repsManager.performRequest(with: repURL)
                        
                      print("Current data: \(data["city"])")
                    }
              
            } else {
                self?.loggedIn = false
                print("Not Logged in")

                }
            
        }
        

        repsManager.performRequest(with: repURL)
        tableView.reloadData()
    }
}

extension ViewController: RepsManagerDelegate{
    func didUpdateReps(_ repsManager: RepsManager, reps: [[String: String]]){
        self.repsManager.reps = reps
        DispatchQueue.main.async {
            print("reloading data")
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)


    }
}

extension ViewController: UITableViewDataSource{
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return (self.repsManager.repsDecoded?.offices.count) ?? 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.repsManager.reps?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.repsManager.reps?[indexPath.row]["name"]
        cell.detailTextLabel?.text = self.repsManager.reps?[indexPath.row]["office"]
        
        return cell
    }
}

extension ViewController{
    func ViewProfile(){
    let vc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
    vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)}
    
    func Login(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        vc.title = "Login"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func Logout(){
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

