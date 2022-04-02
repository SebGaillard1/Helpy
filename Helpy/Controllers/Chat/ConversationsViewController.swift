//
//  ConversationsViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 06/03/2022.
//

import UIKit
//import JGProgressHUD

class ConversationsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var conversationsTableView: UITableView!
    @IBOutlet weak var noConvLabel: UILabel!
    
    //MARK: - Properties
    //private let spinner = JGProgressHUD(style: .dark)
    
    private var conversations = [Conversation]() {
        didSet {
            conversations.isEmpty ? (noConvLabel.isHidden = false) : (noConvLabel.isHidden = true)
        }
    }
    private var receiverUid: String?
    private var receiverName: String?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
        conversationsTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "conversationCell")
        
        fetchConversations()
    }
    
    private func fetchConversations() {
        FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
            if error == nil {
                self.conversations = conversations
                self.conversationsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueId.conversationsToChat {
            guard
                let receiverUid = receiverUid,
                let receiverName = receiverName
            else {
                return
            }

            let vc = segue.destination as! ChatViewController
            vc.otherName = receiverName
            vc.otherUid = receiverUid
        }
    }
}

//MARK: - Extensions
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: conversations[indexPath.row])
        return cell
    }
}

extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        receiverUid = conversations[indexPath.row].otherUid
        receiverName = conversations[indexPath.row].otherName
        performSegue(withIdentifier: Constants.SegueId.conversationsToChat, sender: self)
    }
}
