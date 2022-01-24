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
    
    var showMenu = true
    
    let indexCount = 0
    
    let db = Firestore.firestore()
    
    var addressString: String = ""
    
    var userAddressString: String = ""
    
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
        
        tableView.register(UINib(nibName: "RepCell", bundle: nil), forCellReuseIdentifier: "repCell")
        electionTableView.register(UINib(nibName: "RepCell", bundle: nil), forCellReuseIdentifier: "repCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(addressDeleted), name: Notification.Name("addressDeleted"), object: nil)

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
                        
                        let string = "\(data["address"] ?? "") \(data["city"] ?? "") \(data["state"] ?? "") \(data["zip"] ?? "")"
                        self?.addressString = string.replacingOccurrences(of: " ", with: "%20")
                        self?.userAddressString = string.replacingOccurrences(of: " ", with: "%20")
                        repURL = "\(self!.repsManager.baseURL)\(self!.repsManager.key)&address=\(self!.addressString)"
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
    
    @objc func addressDeleted(){
        addressString = ""
        self.detailsButton.configuration?.subtitle = "No Address Found"
        let repURL = "\(self.repsManager.baseURL)\(self.repsManager.key)&address=\(self.addressString)"
        self.repsManager.performRequest(with: repURL)
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
        DispatchQueue.main.async {
            self.electionTableView.reloadData()
        }
    }
}


////////////////////////////
///// MARK: - TABLE VIEW DELEGATE
////////////////////////////
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.tableView {
            let rep = self.repsManager.reps?[indexPath.row] ?? [:]
            let vc = storyboard?.instantiateViewController(withIdentifier: "repDetail") as! RepInfoViewController
            vc.title = "Representative"
            vc.official = rep
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if tableView == self.electionTableView {
            let election = self.electionsManager.elections?[indexPath.row] ?? [:]
            let vc = storyboard?.instantiateViewController(withIdentifier: "electionDetail") as! ElectionDetailViewController
            vc.title = "Election"
            vc.electionTitle = election["name"] ?? ""
            vc.electionID = election["id"] ?? ""
            vc.addressString = addressString
//            vc.official = rep
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60 //or whatever you need
    }
    
}


////////////////////////////
///// MARK: - TABLE VIEW DATA SOURCE
////////////////////////////
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as! RepCell
            cell.nameLabel?.text = self.repsManager.reps?[indexPath.row]["name"]
            cell.titleLabel?.text = self.repsManager.reps?[indexPath.row]["office"]
            
            if(self.repsManager.reps?[indexPath.row]["party"]?.prefix(1) == "D"){
                cell.partyImage.tintColor = UIColor(named: "ThemeDems")
            }
            if(self.repsManager.reps?[indexPath.row]["party"]?.prefix(1) == "R"){
                cell.partyImage.tintColor = UIColor(named: "ThemeGop")
            }
            
            return cell
        }
        if tableView == self.electionTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as! RepCell
            cell.nameLabel?.text = self.electionsManager.elections?[indexPath.row]["name"]
            cell.titleLabel?.text = "Election Day: \(String(describing:  self.electionsManager.elections?[indexPath.row]["date"] ?? ""))"
            cell.partyImage.isHidden = true

            return cell
        }
        else{
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
    }
}

////////////////////////////
///// MARK: - MENU
////////////////////////////
extension ViewController{
    
    func ViewProfile(){
    let vc = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        vc.title = "Profile"
        vc.addressString = userAddressString
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
        self.showMenu = false
        loadMenu()
    }
    
    func Logout(){
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
            self.showMenu = false
        }
        else{
            self.menuItems = ["Login", "Register", "Continue as Guest"]
            
        }
        
        let menuView = BTNavigationDropdownMenu(title: "Menu", items: menuItems)
        if(showMenu){
            menuView.show()
        }
        self.navigationItem.titleView = menuView
        menuView.menuTitleColor = UIColor(named: "ThemeWhite")
        menuView.cellTextLabelColor = UIColor(named: "ThemeWhite")
        menuView.cellBackgroundColor = UIColor(named: "ThemePurple")
        menuView.checkMarkImage = nil
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            switch self?.menuItems[indexPath] {
                case "Profile":
                    self?.ViewProfile()
                case "Login":
                    self?.Login()
                case "Logout":
                    self?.Logout()
                case "Register":
                    self?.Register()
                case "Continue as Guest":
                    self?.ContinueAsGuest()
                default:
                    print("Enjoy your day!")
            }
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        addressString = (searchBar.text?.replacingOccurrences(of: " ", with: "%20") ?? addressString)
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

