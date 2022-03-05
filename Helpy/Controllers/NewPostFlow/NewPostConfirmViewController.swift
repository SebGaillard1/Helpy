//
//  NewPostConfirmViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import UIKit

class NewPostConfirmViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var newPostImageView: UIImageView!
    @IBOutlet weak var publishUIButton: UIButton!
    
    //MARK: - Properties
    var newPost: Post!
    let segueIdToSuccess = "newPostConfirmationToSuccess"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        newPostImageView.roundedCorners()
        fillAllFields()
    }
    
    private func fillAllFields() {
        titleLabel.text = newPost.title
        categoryLabel.text = newPost.category
        descriptionLabel.text = newPost.description
        localityLabel.text = newPost.locality
        postalCodeLabel.text = newPost.postalCode
        newPostImageView.image = newPost.image
    }
    
    //MARK: - Actions
    @IBAction func publishDidTouch(_ sender: Any) {
        publishUIButton.isEnabled = false
        publishNewPost()
    }
    
    private func publishNewPost() {
        FirebaseDatabaseManager.shared.savePost(post: newPost) { error in
            if error == nil {
                self.performSegue(withIdentifier: self.segueIdToSuccess, sender: self)
            } else {
                let ac = UIAlertController(title: "Erreur", message: "Aie, impossible de poster l'annonce. L'erreur suivante vient de se produire : \(error!)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                
                self.publishUIButton.isEnabled = true
            }
        }
    }
}
