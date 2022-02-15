//
//  NewPostPhotoViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import UIKit

class NewPostPhotoViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var newPostImageView: UIImageView!
        
    //MARK: - Properties
    var newPost: Post!
    var image: UIImage? {
        didSet {
            newPostImageView.image = image
            newPost.image = image
        }
    }
    
    let segueIdToConfirmation = "newPostPhotoToConfirmation"

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        newPostImageView.roundedCorners()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(importPicture))
        newPostImageView.addGestureRecognizer(recognizer)
    }
    
    //MARK: - Actions
    @IBAction func continueToNextPageDidTouch(_ sender: Any) {
        if image == nil {
            let ac = UIAlertController(title: "Êtes-vous sûr ?", message: "Ajouter une image permet de vous démarquer ! Si vous n'ajoutez pas de photo, une image par défaut sera utilisée.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ajouter une photo", style: .default, handler: nil))
            ac.addAction(UIAlertAction(title: "Continuer sans image personnalisée", style: .default, handler: { _ in
                self.performSegue(withIdentifier: self.segueIdToConfirmation, sender: self)
            }))
            present(ac, animated: true)
        } else {
            performSegue(withIdentifier: segueIdToConfirmation, sender: self)
        }
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToConfirmation {
            let destinationVC = segue.destination as! NewPostConfirmViewController
            destinationVC.newPost = newPost
        }
    }
}

//MARK: - Extensions
extension NewPostPhotoViewController: UINavigationControllerDelegate {
    
}

extension NewPostPhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        newPostImageView.contentMode = .scaleAspectFill
        dismiss(animated: true)
        self.image = image
    }
}
