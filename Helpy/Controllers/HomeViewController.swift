//
//  HomeViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var postCollectionView: UICollectionView!
    
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
    
    let postCellId = "postCell"
    
    var postExemple: Post?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: postCellId)
        
        postExemple = Post(title: "Gardes enfants", category: "Services", locality: "Lyon", postalCode: "69002", postDate: Date(), proUid: "zrerere", description: "Je garde vos enfants", image: UIImage(named: "garde-enfant")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        handle = Auth.auth().addStateDidChangeListener { _, user in
            if user == nil {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //MARK: - Actions
    
    
}

//@IBAction func signOutDidTouch(_ sender: Any) {
//        // 1
//        guard let user = Auth.auth().currentUser else { return }
//        let onlineRef = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: "online/\(user.uid)")
//        // 2
//        onlineRef.removeValue { error, _ in
//          // 3
//          if let error = error {
//            print("Removing online failed: \(error)")
//            return
//          }
//          // 4
//          do {
//            try Auth.auth().signOut()
//            self.navigationController?.popViewController(animated: true)
//          } catch let error {
//            print("Auth sign out failed: \(error)")
//          }
//        }
//
//    }

//MARK: - Extension
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(withPost: postExemple!)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 2.2, height: self.view.bounds.height / 3)
    }
}
