//
//  VoterInfoViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/16/22.
//

import UIKit
import BTNavigationDropdownMenu

class VoterInfoViewController: UIViewController {

    

    var voterInfoManager = VoterInfoManager()
    var addressString: String = ""
    

    @IBOutlet weak var voterInfoTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        voterInfoManager.delegate = self
        let voterURL = self.voterInfoManager.baseURL+addressString
        print(addressString)
        voterInfoTableView.delegate = self
        voterInfoTableView.dataSource = self
        
        
        self.voterInfoManager.performRequest(urlString: voterURL)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            loadMenu()
    }
    
}

extension VoterInfoViewController: VoterInfoManagerDelegate{
    func didUpdateVoterInfo(_ voterInfoManager: VoterInfoManager, voterInfo: Array<Dictionary<String, String>>) {
        print(voterInfo)
        self.voterInfoManager.voterInfo = voterInfo
        print(self.voterInfoManager.voterInfo)
        DispatchQueue.main.async {
            self.voterInfoTableView.reloadData()
        }
    }
    

}

extension VoterInfoViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        voterInfoManager.voterInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = voterInfoTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.voterInfoManager.voterInfo[indexPath.row]["name"]
        cell.detailTextLabel?.text = self.voterInfoManager.voterInfo[indexPath.row]["value"]

        return cell
    }
}

extension VoterInfoViewController: UITableViewDelegate{


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(voterInfoManager.voterInfo[indexPath.row]["type"] == "link"){
            guard let urlString = self.voterInfoManager.voterInfo[indexPath.row]["value"] else { return  }
            if let url = URL(string: urlString)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
    }
}

extension VoterInfoViewController{
    func loadMenu(){
        let menuView = BTNavigationDropdownMenu(title: "Resources", items: ["Home"])

        self.navigationItem.titleView = menuView
        menuView.menuTitleColor = UIColor(named: "ThemeWhite")
        menuView.cellTextLabelColor = UIColor(named: "ThemeWhite")
        menuView.cellBackgroundColor = UIColor(named: "ThemePurple")
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
