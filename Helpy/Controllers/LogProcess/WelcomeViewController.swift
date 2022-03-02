//
//  ViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import UIKit
import Firebase
import AVFoundation

class WelcomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var videoUIImageView: UIImageView!
    
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
    
    let segueIdWelcomeToClientHome = "welcomeToClientHome"
    let segueIdWelcomeToProHome = "welcomeToProHome"

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        playVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 1
        handle = Auth.auth().addStateDidChangeListener { _, user in
          // 2
            guard let user = user else {
                self.navigationController?.popToRootViewController(animated: true)
                self.videoUIImageView.isHidden = true
                return
            }
            
            Constants.FirebaseHelper.clientRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                if querySnapshot?.isEmpty == false && error == nil {
                    UIView.setAnimationsEnabled(false)
                    self.performSegue(withIdentifier: self.segueIdWelcomeToClientHome, sender: nil)
                    self.videoUIImageView.isHidden = true
                }
            }
            
            Constants.FirebaseHelper.proRef.whereField("uid", isEqualTo: user.uid).getDocuments { querySnapshot, error in
                if querySnapshot?.isEmpty == false && error == nil {
                    UIView.setAnimationsEnabled(false)
                    self.performSegue(withIdentifier: self.segueIdWelcomeToProHome, sender: nil)
                    self.videoUIImageView.isHidden = true
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIView.setAnimationsEnabled(true)
        
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "launchVideo", ofType: "mp4") else {
            print("Pas trouvé")
            return }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoUIImageView.bounds
        videoUIImageView.layer.addSublayer(playerLayer)
        player.play()
    }
}
