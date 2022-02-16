//
//  ProSettingsViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 16/02/2022.
//

import UIKit
import Firebase

class ProSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signOutDidTouch(_ sender: Any) {
        do {
          try Auth.auth().signOut()
          self.navigationController?.popViewController(animated: true)
        } catch let error {
          print("Auth sign out failed: \(error)")
        }
    }
}
