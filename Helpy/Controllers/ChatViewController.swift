//
//  ChatViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/03/2022.
//

import UIKit

class ChatViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    //MARK: - Properties
    var messages = [Message]()
    var otherUid = ""
    var otherName = ""
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        title = otherName
        
        FirebaseFirestoreChatManager.shared.getConversationMessages(with: otherUid) { error, messages in
            if error == nil {
                self.messages = messages
                self.messageTableView.reloadData()
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func sendDidTouch(_ sender: UIButton) {
        guard let message = messageTextField.text, message.isEmpty == false else {
            presentError(error: "Message vide !")
            return
        }
        
        FirebaseFirestoreChatManager.shared.sendMessage(message: message, receiverUid: otherUid, receiverName: otherName) { error in
            if let error = error {
                self.presentError(error: error)
            } else {
                self.messageTextField.text = ""
            }
        }
    }
    
    private func presentError(error: String) {
        let ac = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}

//MARK: - Extensions
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: messages[indexPath.row])
        
        return cell
    }
}
