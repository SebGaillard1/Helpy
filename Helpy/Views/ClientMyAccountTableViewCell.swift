//
//  ClientMyAccountTableViewCell.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 02/03/2022.
//

import UIKit

class ClientMyAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "ClientMyAccountTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with option: MyAccountOption) {
        titleLabel.text = option.title
        iconImageView.image = option.icon
    }
    
}
