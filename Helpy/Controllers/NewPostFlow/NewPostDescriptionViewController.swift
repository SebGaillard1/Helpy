//
//  NewPostDescriptionViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import UIKit

class NewPostDescriptionViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var continueToNextPageButton: UIButton!
    
    
    //MARK: - Properties
    var newPost: Post!
    
    var isTitleCorrectLenght = false
    var isDescriptionCorrectLenght = false
    
    let segueIdToAddress = "newPostDescriptionToAddress"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        
        titleTextField.text = newPost.title
        continueToNextPageButton.isEnabled = false
        
        checkTitleValidity()
    }
    
    //MARK: - Actions
    @IBAction func titleTextFieldEditingChanged(_ sender: Any) {
        checkTitleValidity()
    }
    
    @IBAction func continueToNextPageDidTouch(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        newPost.title = title
        newPost.description = descriptionTextView.text
        performSegue(withIdentifier: segueIdToAddress, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToAddress {
            let destinationVC = segue.destination as! NewPostAddressViewController
            destinationVC.newPost = newPost
        }
    }
    
    //MARK: - Private
    private func checkTitleValidity() {
        guard let title = titleTextField.text else { return }
        isTitleCorrectLenght = title.isTitleCorrectLenght
        
        checkTitleAndDescriptionValidity()
    }
    
    private func checkDescriptionValidity(description: String) {
        let isDescriptionCorrectLenght = (description.count > 10 && description.count < 1000)
        self.isDescriptionCorrectLenght = isDescriptionCorrectLenght
        
        checkTitleAndDescriptionValidity()
    }
    
    private func checkTitleAndDescriptionValidity() {
        if isDescriptionCorrectLenght && isTitleCorrectLenght {
            continueToNextPageButton.isEnabled = true
        } else {
            continueToNextPageButton.isEnabled = false
        }
    }
}

//MARK: - Extension
extension NewPostDescriptionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkDescriptionValidity(description: textView.text)
    }
}

