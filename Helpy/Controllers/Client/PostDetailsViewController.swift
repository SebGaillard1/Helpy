//
//  PostDetailsViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 28/02/2022.
//

import UIKit

class PostDetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postCityAndPostalCodeLabel: UILabel!
    @IBOutlet weak var postPostedByLabel: UILabel!
    
    //MARK: - Properties
    var post: Post!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
    }

    private func setupUi() {
        postImageView.image = post.image
        postTitleLabel.text = post.title
        postCategoryLabel.text = post.category
        postDescriptionLabel.text = post.description
        postCityAndPostalCodeLabel.text = "\(post.locality) \(post.postalCode)"
        postPostedByLabel.text = post.proUid // A remplacer par le nom du pro
        if let date = post.postDate {
            postDateLabel.text = "\(date)"
        }
    }
}
