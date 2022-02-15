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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var newPostImageView: UIImageView!
    
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
        descriptionTextView.text = newPost.description
        localityLabel.text = newPost.locality
        postalCodeLabel.text = newPost.postalCode
        newPostImageView.image = newPost.image
    }
    
    //MARK: - Actions
    @IBAction func publishDidTouch(_ sender: Any) {
        // if tout est valide
        performSegue(withIdentifier: segueIdToSuccess, sender: self)
    }
}
