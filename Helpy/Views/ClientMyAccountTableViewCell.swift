//
//  ClientMyAccountTableViewCell.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 02/03/2022.
//

import UIKit

class ClientMyAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var iconContainerUIView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "ClientMyAccountTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconContainerUIView.clipsToBounds = true
        iconContainerUIView.layer.cornerRadius = 8
        iconContainerUIView.layer.masksToBounds = true
        
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with option: MyAccountOption) {
        titleLabel.text = option.title
        iconImageView.image = option.icon
        iconContainerUIView.backgroundColor = option.iconBackground
    }
    
}
