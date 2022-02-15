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

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = newPost.title
        continueToNextPageButton.isEnabled = false
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
