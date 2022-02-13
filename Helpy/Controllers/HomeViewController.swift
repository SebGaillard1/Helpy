//
//  HomeViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        handle = Auth.auth().addStateDidChangeListener { _, user in
            // 2
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
    @IBAction func signOutDidTouch(_ sender: Any) {
        // 1
        guard let user = Auth.auth().currentUser else { return }
        let onlineRef = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: "online/\(user.uid)")
        // 2
        onlineRef.removeValue { error, _ in
          // 3
          if let error = error {
            print("Removing online failed: \(error)")
            return
          }
          // 4
          do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
          } catch let error {
            print("Auth sign out failed: \(error)")
          }
        }

    }
}
