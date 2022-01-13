//
//  ViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var repsManager = RepsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var repURL = "\(repsManager.baseURL)\(repsManager.key)?address=1263%20Pacific%20Ave.%20Kansas%20City%20KS"

        repsManager.performRequest(with: repURL)
    }
}

