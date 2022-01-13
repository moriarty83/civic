//
//  RepsManager.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import Foundation

struct RepsManager {
//    var delegate: RepManagerDelegate?
    
    let key = K.Reps.api_key! as String

    var baseURL = "https://www.googleapis.com/civicinfo/v2/representatives?key="
    
    var address = ""
    
    func performRequest(with urlString: String){
        print(urlString)
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error ) in
                if error != nil{
                    print(error)
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                print(response)
                print(json)
            }
            task.resume()
        }
    }
}
    
        

    
    

