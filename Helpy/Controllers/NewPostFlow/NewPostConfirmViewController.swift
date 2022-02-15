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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var newPostImageView: UIImageView!
    
    //MARK: - Properties
    var newPost: Post!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        newPostImageView.roundedCorners()
        fillAllFields()
    }
    
    //MARK: - Actions
    private func fillAllFields() {
        titleLabel.text = newPost.title
        print(newPost.description)
        descriptionTextView.text = newPost.description
        localityLabel.text = newPost.locality
        postalCodeLabel.text = newPost.postalCode
        newPostImageView.image = newPost.image
    }
}
