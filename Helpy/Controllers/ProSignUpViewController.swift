//
//  ProSignUpViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 13/02/2022.
//

import UIKit

class ProSignUpViewController: UIViewController, JobsTableViewControllerDelegate {
    @IBOutlet weak var chooseJobButton: UIButton!
    
    let segueToJobs = "proSignUpToJobs"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToJobs {
            let destinationVC = segue.destination as! JobsTableViewController
            destinationVC.delegate = self
        }
    }

    @IBAction func chooseJobDidTouch(_ sender: Any) {
        performSegue(withIdentifier: segueToJobs, sender: self)
    }
    
    internal func sendJobSelected(job: String) {
        chooseJobButton.setTitle(job, for: .normal)
    }
}
