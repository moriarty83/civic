//
//  RepInfoViewController.swift
//  Civic
//
//  Created by Christopher M Moriarty on 1/19/22.
//

import UIKit

class RepInfoViewController: UIViewController {
    
    var imageUrlString = ""
    let unknownImageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/434px-Unknown_person.jpg")
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var partyLabel: UILabel!
    
    @IBOutlet weak var websiteButton: UIButton!
    
    @IBOutlet weak var social1Button: UIButton!
    
    @IBOutlet weak var social2Button: UIButton!
    
    var official: [String:String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        print(official)
        imageUrlString = official["photoUrl"] ?? imageUrlString
        imageUrlString = imageUrlString.replacingOccurrences(of: "http://", with: "https://")
        namelabel.text = official["name"]
        partyLabel.text = official["party"]
        
        if (imageUrlString != ""){
            populateImage(imageView: image, url: (URL(string: imageUrlString) ?? unknownImageUrl)!)
        }
        populateButtons()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapWebsite(_ sender: UIButton) {
        
        guard let urlString = self.official["Website"] else { return  }
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapSocial1(_ sender: Any) {
        guard let urlString = self.official["social1Link"] else { return  }
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func didTapSocial2(_ sender: Any) {
        guard let urlString = self.official["social2Link"] else { return  }
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func populateImage(imageView: UIImageView, url: URL) {
        print("loading image")
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async { //all changes to UI must be called on main thread
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse{
                    if(response.statusCode != 200){
                        return
                    }
                    
                }
//                transform your data and update UI
                if let image = UIImage(data: data!) {

                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
        }.resume()
    }
    
    func populateButtons(){
        if(official["social1Handle"] != ""){
            social1Button.setTitle(official["social1Type"], for: .normal)
        }
        else{
            social1Button.isHidden = true
        }
        
        if(official["social2Handle"] != ""){
            social2Button.setTitle(official["social2Type"], for: .normal)
        }
        else{
            social2Button.isHidden = true
        }
    }
    
}
