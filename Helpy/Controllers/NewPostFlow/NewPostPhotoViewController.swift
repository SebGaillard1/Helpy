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
            newPost.imageUrl = "image à gérer"
        }
    }

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        newPostImageView.layer.masksToBounds = true
        newPostImageView.layer.cornerRadius = 8
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(importPicture))
        newPostImageView.addGestureRecognizer(recognizer)
    }
    
    //MARK: - Actions
    @IBAction func continueToNextPageDidTouch(_ sender: Any) {
        if image == nil {
            let ac = UIAlertController(title: "Êtes-vous sûr ?", message: "Ajouter une image permet de vous démarquer ! Si vous n'ajoutez pas de photo, une image par défaut sera utilisée.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ajouter une photo", style: .default, handler: nil))
            ac.addAction(UIAlertAction(title: "Continuer sans image personnalisée", style: .default, handler: { _ in
                // perform segue
            }))
            present(ac, animated: true)
        }
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
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
