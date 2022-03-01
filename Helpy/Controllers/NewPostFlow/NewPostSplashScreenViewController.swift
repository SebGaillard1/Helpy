//
//  NewPostSplashScreenViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 01/03/2022.
//

import UIKit

class NewPostSplashScreenViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    let segueIdToTitle = "newPostSplashScreenToTitle"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = "Postez votre annonce et devenez helper !\nDevenir helper c'est rejoindre une communauté et proposer son savoir faire à des xxxxx personnes 🤝"
    }
    
    @IBAction func startDidTouch(_ sender: Any) {
        performSegue(withIdentifier: segueIdToTitle, sender: self)
    }
}
