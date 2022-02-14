//
//  CollectionViewCell.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 14/02/2022.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postLocalityAndPostalCodeLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        postImageView.layer.cornerRadius = 8
    }
    
    func configure(withPost post: Post) {
        postImageView.image = post.image
        postTitleLabel.text = post.title
        postCategoryLabel.text = post.category
        postLocalityAndPostalCodeLabel.text = "\(post.locality) \(post.postalCode)"
        postDateLabel.text = "\(post.postDate)"
    }

}
