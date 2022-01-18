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
    
    var menuItems = ["Welcome"]
    
    let indexCount = 0
    
    let db = Firestore.firestore()
    
    var addressString: String = ""
    
    var repsManager = RepsManager()
    
    var electionsManager = ElectionManager()
    
    weak var handle: AuthStateDidChangeListenerHandle?
    
    var loggedIn = false
    
    var runViewWillAppear = false;

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var electionTableView: UITableView!
        
    @IBOutlet weak var detailsButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repsManager.delegate = self
        electionsManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        electionTableView.delegate = self
        electionTableView.dataSource = self
        searchBar.delegate = self

        var repURL = "\(repsManager.baseURL)\(repsManager.key)&address=\(addressString)"

        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if ((user) != nil) {
                self?.loggedIn = true
                self?.db.collection("addresses").document(user!.uid)
                    .addSnapshotListener { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                      }
                      guard let data = document.data() else {
                        print("Document data was empty.")
                          self!.loadMenu()
                          self!.runViewWillAppear = true
                        return
                      }
                        
                        var string = "\(data["address"] ?? "") \(data["city"] ?? "") \(data["state"] ?? "") \(data["zip"] ?? "")"
                        self?.addressString = string.replacingOccurrences(of: " ", with: "%20")
                        repURL = "\(self!.repsManager.baseURL)\(self!.repsManager.key)&address=\(self!.addressString)"
                        print(repURL)
                        self!.repsManager.performRequest(with: repURL)
                        self!.detailsButton.configuration?.subtitle = "\(self?.addressString.replacingOccurrences(of: "%20", with: " ") ?? "")"
                        self!.loadMenu()
                        self!.runViewWillAppear = true
                    }
              
            } else {
                self?.loggedIn = false
                self!.loadMenu()
                self!.runViewWillAppear = true
                }
        }
        
        repsManager.performRequest(with: repURL)
        electionsManager.performRequest()
        tableView.reloadData()
        electionTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Nav Menu
        if(runViewWillAppear){
            loadMenu()
        }
        
    }
    @IBAction func didTapDetails(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "voterDetail") as! VoterInfoViewController
        vc.title = "Voting Info"
        vc.addressString = addressString
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapRefresh(_ sender: Any) {
        reloadViewFromNib()
    }
}

extension ViewController: RepsManagerDelegate{
    func didUpdateReps(_ repsManager: RepsManager, reps: [[String: String]]){
        self.repsManager.reps = reps
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: ElectionManagerDelegate{
    func didUpdateElections(_ electionManager:   ElectionManager, elections: [[String : String]]) {
        self.electionsManager.elections = elections
        print(elections)
        DispatchQueue.main.async {
            self.electionTableView.reloadData()
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
        if tableView == self.tableView {
            return (self.repsManager.reps?.count) ?? 0
        }
        
        if tableView == self.electionTableView {
            return (self.electionsManager.elections?.count) ?? 0
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.repsManager.reps?[indexPath.row]["name"]
            cell.detailTextLabel?.text = self.repsManager.reps?[indexPath.row]["office"]
            
            return cell
        }
        if tableView == self.electionTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "electionCell", for: indexPath)
            cell.textLabel?.text = self.electionsManager.elections?[indexPath.row]["name"]
            cell.detailTextLabel?.text = "Election Day: \(String(describing:  self.electionsManager.elections?[indexPath.row]["date"] ?? ""))"

            return cell
        }
        else{
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
    }
}

extension ViewController{
    
    func ViewProfile(){
    let vc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
    vc.title = "Profile"
        vc.addressString = addressString
        navigationController?.pushViewController(vc, animated: true)}
    
    func Login(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        vc.title = "Login"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ContinueAsGuest(){
        addressString = ""
        repsManager.reps = []
        tableView.reloadData()
    }
    
    func Logout(){
        print("logging out")
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.repsManager.reps = []
            self.tableView.reloadData()
            self.addressString = ""
            self.detailsButton.configuration?.subtitle = "No Address Found"
            self.viewWillAppear(true)
            self.menuItems = ["Login", "Register", "Continue as Guest"]
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        loadMenu()
    }
    
    func Register(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "register") as! RegisterViewController
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMenu(){
        
        if(self.loggedIn){
            self.menuItems = ["Profile", "Logout"]
        }
        else{
            self.menuItems = ["Login", "Register", "Continue as Guest"]
            
        }
        
        let menuView = BTNavigationDropdownMenu(title: "Menu", items: menuItems)
        if(!loggedIn){
            menuView.show()
        }
        self.navigationItem.titleView = menuView
        menuView.cellBackgroundColor = UIColor(named: "ThemePurple")
        menuView.checkMarkImage = nil
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item  \(String(describing: self?.menuItems[indexPath]))")
            switch self?.menuItems[indexPath] {
                case "Profile":
                    self?.ViewProfile()
                case "Login":
                    self?.Login()
                case "Logout":
                    self?.Logout()
                case "Register":
                    self?.Register()
                default:
                    print("Enjoy your day!")
            }
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchURL = "\(repsManager.baseURL)\(repsManager.key)&address=\(searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? addressString)"
        
        detailsButton.configuration?.subtitle = searchBar.text
        repsManager.performRequest(with: searchURL)
    }
    
}

extension ViewController{
    func reloadViewFromNib() {
        addressString = ""
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}

