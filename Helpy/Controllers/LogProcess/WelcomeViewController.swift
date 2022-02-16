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
    let clientRef = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForClients)
    let proRef = Database.database(url: FirebaseHelper.databaseUrl).reference(withPath: FirebaseHelper.pathForProfessionals)
    var refObservers: [DatabaseHandle] = []
    
    var handle: AuthStateDidChangeListenerHandle?
    
    let segueIdWelcomeToClientHome = "welcomeToClientHome"
    let segueIdWelcomeToProHome = "welcomeToProHome"

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 1
        handle = Auth.auth().addStateDidChangeListener { _, user in
          // 2
            guard let user = user else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            
            self.clientRef.observe(.value) { snapshot in
                if snapshot.hasChild(user.uid) {
                    self.performSegue(withIdentifier: self.segueIdWelcomeToClientHome, sender: nil)
                }
            }
            
            self.proRef.observe(.value) { snapshot in
                if snapshot.hasChild(user.uid) {
                    self.performSegue(withIdentifier: self.segueIdWelcomeToProHome, sender: nil)

                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }


}

