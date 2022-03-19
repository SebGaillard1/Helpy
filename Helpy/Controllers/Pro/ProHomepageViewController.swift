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
    
    //MARK: - Properties
    let postCellId = "postCell"
    
    var myPosts = [Post]()
    var selectedPost: Post?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPostsCollectionView.dataSource = self
        myPostsCollectionView.delegate = self
        myPostsCollectionView.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: postCellId)
        
        getMyPosts()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueId.proHomeToPostDetails {
            let destinationVC = segue.destination as! PostDetailsViewController
            destinationVC.post = selectedPost
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

