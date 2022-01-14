//
//  RepsManager.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import Foundation

protocol RepsManagerDelegate{
    func didUpdateReps(_ repsManager: RepsManager, repsData: RepsData)
}

struct RepsManager {
    var delegate: RepsManagerDelegate?
    
    var repsData: RepsData?
    
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
                    self.delegate?.didUpdateReps(self, repsData: self.parseJSON(safeData)!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data)->RepsData?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RepsData.self, from: data)
            return decodedData
            
        }
        catch{
            print(error)
            return nil
        }
    }
}


    
        

    
    

