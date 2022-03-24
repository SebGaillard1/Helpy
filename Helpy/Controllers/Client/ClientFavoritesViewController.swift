//
//  ClientFavoritesViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 02/03/2022.
//

import UIKit

class ClientFavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
