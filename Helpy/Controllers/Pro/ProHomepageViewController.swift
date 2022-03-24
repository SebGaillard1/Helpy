//
//  ProHomepageViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/02/2022.
//

import UIKit
import Firebase

class ProHomepageViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var myPostsCollectionView: UICollectionView!
    @IBOutlet weak var myConversationsTableView: UITableView!
    
    @IBOutlet weak var noPostLabel: UILabel!
    @IBOutlet weak var noConversationsLabel: UILabel!
    
    //MARK: - Properties
    let postCellId = "postCell"
    let messageCellId = "conversationCell"
    
    var myPosts = [Post]() {
        didSet {
            if !myPosts.isEmpty {
                noPostLabel.isHidden = true
            }
        }
    }
    var selectedPost: Post?
    
    var myConversations = [Conversation]() {
        didSet {
            if !myConversations.isEmpty {
                noConversationsLabel.isHidden = true
            }
        }
    }
    var selectedConversation: Conversation?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPostsCollectionView.dataSource = self
        myPostsCollectionView.delegate = self
        myPostsCollectionView.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: postCellId)
        
        myConversationsTableView.dataSource = self
        myConversationsTableView.delegate = self
        myConversationsTableView.register(UINib.init(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: messageCellId)
        
        getMyPosts()
        getRecentMessages()
        FirebaseDatabaseManager.shared.saveUserNameToUserDefaults(userType: .pro)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func getMyPosts() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseDatabaseManager.shared.getPostFrom(pro: userUid) { posts in
            self.myPosts = posts
            self.myPostsCollectionView.reloadData()
            
            for (index, post) in posts.enumerated() {
                FirebaseDatabaseManager.shared.downloadImage(from: post.imageUrl) { postImage in
                    var post = post
                    post.image = postImage
                    self.myPosts[index] = post
                    self.myPostsCollectionView.reloadData()
                }
            }
        }
    }
    
    private func getRecentMessages() {
        FirebaseFirestoreChatManager.shared.getAllConversationsWithLastMessage { error, conversations in
            if error == nil && !conversations.isEmpty {
                self.myConversations = conversations
                self.myConversationsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueId.proHomeToPostDetails {
            let destinationVC = segue.destination as! PostDetailsViewController
            destinationVC.post = selectedPost
        } else if segue.identifier == Constants.SegueId.proHomepageToChat {
            guard let otherName = selectedConversation?.otherName,
                  let otherUid = selectedConversation?.otherUid else { return }
            
            let destinationVc = segue.destination as! ChatViewController
            destinationVc.otherName = otherName
            destinationVc.otherUid = otherUid
        }
    }
}

//MARK: - Extensions
extension ProHomepageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(withPost: myPosts[indexPath.row])
        
        return cell
    }
}

extension ProHomepageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPost = myPosts[indexPath.row]
        performSegue(withIdentifier: Constants.SegueId.proHomeToPostDetails, sender: self)
    }
}

extension ProHomepageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.65, height: height)
    }
}

extension ProHomepageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageCellId, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
    
        cell.nameLabel.text = myConversations[indexPath.row].otherName
        cell.messageLabel.text = myConversations[indexPath.row].lastMessage
        return cell
    }
}

extension ProHomepageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedConversation = myConversations[indexPath.row]
        performSegue(withIdentifier: Constants.SegueId.proHomepageToChat, sender: self)
    }
}

