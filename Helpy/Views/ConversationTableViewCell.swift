//
//  ConversationTableViewCell.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/03/2022.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with conversation: Conversation) {
        nameLabel.text = conversation.receiverName
        messageLabel.text = conversation.lastMessage
    }
}
