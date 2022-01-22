//
//  ElectionDetailManager.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/19/22.
//

import Foundation
import SwiftyJSON

protocol ElectionDetailManagerDelegate{
    func didUpdateContestInfo(_ electionDetailManager: ElectionDetailManager, contests: Array<Dictionary<String, String>>)
}


struct ElectionDetailManager{
    var contests: Array<Dictionary<String, String>> = []
    
    var electionDate: String = ""
    
    var delegate: ElectionDetailManagerDelegate?
    
    func performElectionRequest(electionID: String, address: String){
        let urlString = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=\(K.Reps.api_key!)&electionId=\(electionID)&address=\(address)"
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error ) in
                if error != nil{
                    print(error as Any)
                    return
                }
                if let safeData = data {
                    self.delegate?.didUpdateContestInfo(self, contests: swiftyElection(safeData))
                }
            }
            task.resume()
        }
    }
    
    func swiftyElection(_ dataFromNetworking: Data)-> Array<Dictionary<String, String>>{
        var contests: Array<Dictionary<String, String>> = []
        do {
        let json = try JSON(data: dataFromNetworking)
            
            for (_,subJson):(String, JSON) in json["contests"] {
                if(subJson["type"].stringValue == "General"){
                    contests.append(["name": subJson["office"].stringValue])
                }
                if(subJson["type"].stringValue == "Referendum"){
                    contests.append(["name": subJson["referendumTitle"].stringValue])
                }
            }

        }
        catch{
            print(error)

        }
        return contests
        
    }
}
