//
//  ConversationsViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 06/03/2022.
//

import UIKit
import JGProgressHUD

class ConversationsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var conversationsTableView: UITableView!
    @IBOutlet weak var noConvLabel: UILabel!
    
    //MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    
    private let conversations = [String]()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    private func fetchConversations() {
        
    }
}

//MARK: - Extensions
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "Hello World!"
//        content.text = conversations[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.SegueId.conversationsToChat, sender: self)
    }
}
