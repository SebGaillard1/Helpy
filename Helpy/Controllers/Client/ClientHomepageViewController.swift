//
//  HomeViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

class ClientHomepageViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
    
    let postCellId = "postCell"
    let segueIdToPostDetails = "homeToPostDetails"
    
    var posts = [Post]()
    var selectedPost: Post?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: postCellId)
        
        getRecentPosts()
        
        handle = Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        guard let handle = handle else { return }
//        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToPostDetails {
            let destinationVC = segue.destination as! PostDetailsViewController
            destinationVC.post = selectedPost
        }
    }
    
    private func getRecentPosts() {
        FirebaseDatabaseManager.shared.getRecentPosts { posts in
            self.posts = posts
            self.postCollectionView.reloadData()
            
            for (index, post) in posts.enumerated() {
                FirebaseDatabaseManager.shared.downloadImage(from: post.imageUrl) { postImage in
                    var post = post
                    post.image = postImage
                    self.posts[index] = post
                    self.postCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func logOutDidTouch(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
    }
}

//MARK: - Extension
extension ClientHomepageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(withPost: posts[indexPath.row])
        
        return cell
    }
}

extension ClientHomepageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        performSegue(withIdentifier: segueIdToPostDetails, sender: self)
    }
}

extension ClientHomepageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.bounds.width / 2) - 16
        return CGSize(width: width, height: width * 1.4)
    }
}
