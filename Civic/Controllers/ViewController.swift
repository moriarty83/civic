//
//  ViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    
    let testArray = ["tom", "dick", "harry"]
    
    let indexCount = 0
    
    let db = Firestore.firestore()
    
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
                      print("Current data: \(data["city"])")
                    }
              
            } else {
                self?.loggedIn = false
                print("Not Logged in")

                }
            
        }
        
        var repURL = "\(repsManager.baseURL)\(repsManager.key)&address=1263%20Pacific%20Ave.%20Kansas%20City%20KS"

        repsManager.performRequest(with: repURL)
        tableView.reloadData()
    }
}

extension ViewController: RepsManagerDelegate{
    func didUpdateReps(_ repsManager: RepsManager, repsData: RepsData){
        self.repsManager.repsData = repsData
        print("Officials Count: \(self.repsManager.repsData?.officials.count)")
        print(self.repsManager.repsData?.officials[0].name)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.repsManager.repsData?.officials.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.repsManager.repsData?.officials[indexPath.row].name
        
        return cell
    }
}

