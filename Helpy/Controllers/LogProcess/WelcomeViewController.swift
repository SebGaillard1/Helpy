//
//  ViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    //MARK: - Properties
    let ref = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: "client")
    var refObservers: [DatabaseHandle] = []
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let welcomeToSuccess = "welcomeToHome"

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 1
        handle = Auth.auth().addStateDidChangeListener { _, user in
          // 2
          if user == nil {
            self.navigationController?.popToRootViewController(animated: true)
          } else {
            // 3
            self.performSegue(withIdentifier: self.welcomeToSuccess, sender: nil)
          }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }


}

