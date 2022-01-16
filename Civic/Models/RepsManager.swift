//
//  RepsManager.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import Foundation
import SwiftyJSON

protocol RepsManagerDelegate{
    func didUpdateReps(_ repsManager: RepsManager, reps: [[String: String]])
}

struct RepsManager {
    var delegate: RepsManagerDelegate?
    
    var reps: [[String: String]]?
    
    
    let key = K.Reps.api_key! as String

    var baseURL = "https://www.googleapis.com/civicinfo/v2/representatives?key="
    
    var address = ""
    
    func performRequest(with urlString: String){
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error ) in
                if error != nil{
                    print(error as Any)
                    return
                }
                if let safeData = data {
                    self.delegate?.didUpdateReps(self, reps: self.swiftyJson(safeData))
                }
            }
            task.resume()
        }
    }
    
    
    func swiftyJson(_ dataFromNetworking: Data)-> [[String:String]]{
        var officials: [[String:String]] = []
        do {
        let json = try JSON(data: dataFromNetworking)
        print("Swifty JSON")

            print(type(of: json["officials"]))
            let officalNames =  json["officials"].arrayValue.map {$0["name"].stringValue}
            let officalParty =  json["officials"].arrayValue.map {$0["party"].stringValue}

            
            for (key,office):(String, JSON) in json["offices"] {
                
                for (key, value) in office["officialIndices"]{
                    let index: Int = Int(value.rawString()!)!
//                    print(officalNames[index])
//                    print(office["name"])
                    officials.append(["name": officalNames[index], "office": office["name"].stringValue,  "party": officalParty[index]])

                }
            }
        }
        catch{
            print(error)

        }
        return officials
        
    }
    
    
}



    
        

    
    

