//
//  ElectionManager.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import Foundation
import SwiftyJSON

protocol VoterInfoManagerDelegate{
    func didUpdateVoterInfo(_ voterInfoManager: VoterInfoManager, voterInfo: Array<Dictionary<String, String>>)
}

struct VoterInfoManager {
    var delegate: VoterInfoManagerDelegate?

    var voterInfo: Array<Dictionary<String, String>> = []
    
    var baseURL = "https://www.googleapis.com/civicinfo/v2/voterinfo?key=\(K.Reps.api_key!)&electionId=2000&address="
    
    func performRequest(urlString: String){
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error ) in
                if error != nil{
                    print(error as Any)
                    return
                }
                if let safeData = data {
                    self.delegate?.didUpdateVoterInfo(self, voterInfo: swiftyJson(safeData))
                }
            }
            task.resume()
        }
    }
    
    
    func swiftyJson(_ dataFromNetworking: Data)-> Array<Dictionary<String, String>>{
        var voterInfo: Array<Dictionary<String, String>> = []
        do {
        let json = try JSON(data: dataFromNetworking)
            print(json)
            print("Swifty VoterInfo")
            
            voterInfo.append(["name": "Election Adminstrator", "value": json["state"]["electionAdministrationBody"]["name"].stringValue, "type": "info"])
            voterInfo.append(["name": "Election Info", "value": json["state"]["electionAdministrationBody"]["electionInfoUrl"].stringValue, "type": "link"])
            voterInfo.append(["name": "Voter Registration", "value": json["state"]["electionAdministrationBody"]["electionRegistrationUrl"].stringValue])
            voterInfo.append(["name": "Registration Confirmation", "value": json["state"]["electionAdministrationBody"]["electionRegistrationConfirmationUrl"].stringValue])
            voterInfo.append(["name": "Absentee Information", "value": json["state"]["electionAdministrationBody"]["absenteeVotingInfoUrl"].stringValue])
            voterInfo.append(["name": "Voting Location Finder", "value": json["state"]["electionAdministrationBody"]["votingLocationFinderUrl"].stringValue])
            voterInfo.append(["name": "Ballot Info", "value": json["state"]["electionAdministrationBody"]["ballotInfoUrl"].stringValue])

        }
        catch{
            print(error)

        }
        print (voterInfo)
        return voterInfo
        
    }
    
    
}



    
        

    
    

