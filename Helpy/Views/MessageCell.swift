//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Sebastien Gaillard on 24/03/2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBuble: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBuble.layer.cornerRadius = messageBuble.frame.height / 5
        messageLabel.numberOfLines = 0
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with message: Message) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        messageLabel.text = message.content

        if message.receiverUid == currentUid {
            leftView.isHidden = true
            rightView.isHidden = false
            messageBuble.backgroundColor = Constants.appAccentUIColor
        } else {
            leftView.isHidden = false
            rightView.isHidden = true
            messageBuble.backgroundColor = UIColor.green
        }
    }
}
