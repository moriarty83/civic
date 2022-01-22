//
//  ElectionDetailViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/19/22.
//

import UIKit

class ElectionDetailViewController: UIViewController {


    
    
    var electionDetailManager = ElectionDetailManager()
    var electionTitle = ""
    var addressString = ""
    var electionID = ""
    
    @IBOutlet weak var electionTitleLabel: UILabel!
    
    @IBOutlet weak var electionTableView: UITableView!
    
    @IBOutlet weak var pageLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        electionTableView.register(UINib(nibName: "RepCell", bundle: nil), forCellReuseIdentifier: "repCell")

        electionDetailManager.delegate = self
        electionTitleLabel.text = electionTitle
        
        electionTableView.delegate = self
        electionTableView.dataSource = self
        
        electionDetailManager.performElectionRequest(electionID: electionID, address: addressString)
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ElectionDetailViewController: ElectionDetailManagerDelegate{
    func didUpdateContestInfo(_ electionDetailManager: ElectionDetailManager, contests: Array<Dictionary<String, String>>) {
        self.electionDetailManager.contests = contests
        
        DispatchQueue.main.async {
            if(self.electionDetailManager.contests.count < 1){
                self.pageLabel.text = "No additional information associated current address for the "
            }
            self.electionTableView.reloadData()
        }
        
    }
}

extension ElectionDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electionDetailManager.contests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as! RepCell
        cell.nameLabel?.text = self.electionDetailManager.contests[indexPath.row]["name"]
        cell.titleLabel.isHidden = true
        cell.partyImage.isHidden = true

        return cell
    }
}

extension ElectionDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60 //or whatever you need
    }
}
