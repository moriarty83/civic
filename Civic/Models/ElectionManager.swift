//
//  ElectionManager.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import Foundation
import SwiftyJSON

protocol ElectionManagerDelegate{
    func didUpdateElections(_ electionManager: ElectionManager, elections: [[String: String]])
}

struct ElectionManager {
    var delegate: ElectionManagerDelegate?

    var elections: [[String: String]]?
    
    var baseURL = "https://www.googleapis.com/civicinfo/v2/elections?key=\(K.Reps.api_key!)"
    
    func performRequest(){
        if let url = URL(string: baseURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error ) in
                if error != nil{
                    print(error as Any)
                    return
                }
                if let safeData = data {
                    self.delegate?.didUpdateElections(self, elections: self.swiftyJson(safeData))
                }
            }
            task.resume()
        }
    }
    
    
    func swiftyJson(_ dataFromNetworking: Data)-> [[String:String]]{
        var elections: [[String:String]] = []
        do {
        let json = try JSON(data: dataFromNetworking)
            
            for (_, election):(String, JSON) in json["elections"] {
                elections.append(["name": election["name"].stringValue, "date": election["electionDay"].stringValue,  "division": election["ocdDivisionId"].stringValue, "id": election["id"].stringValue])
            }
            
            
        }
        catch{
            print(error)

        }
        elections.remove(at: 0)
        return elections
        
    }
    
    
}



    
        

    
    

