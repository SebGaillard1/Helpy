//
//  PostSearchResultViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 04/03/2022.
//

import UIKit

class PostSearchResultViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    //MARK: - Properties
    let postCellId = "postCell"
    let segueIdToPostDetails = "homeToPostDetails"
    
    var posts = [Post]()
    var selectedPost: Post?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: postCellId)    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToPostDetails {
            let destinationVC = segue.destination as! PostDetailsViewController
            destinationVC.post = selectedPost
        }
    }
}

//MARK: - Extension
extension PostSearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(withPost: posts[indexPath.row])
        
        return cell
    }
}

extension PostSearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        performSegue(withIdentifier: segueIdToPostDetails, sender: self)
    }
}

extension PostSearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.bounds.width / 2) - 16
        return CGSize(width: width, height: width * 1.4)
    }
}
