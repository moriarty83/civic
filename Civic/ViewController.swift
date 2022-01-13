//
//  ViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    var repsManager = RepsManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var repURL = "\(repsManager.baseURL)\(repsManager.key)&address=10003"
        
        repsManager.performRequest(with: repURL)
        
    }
}

