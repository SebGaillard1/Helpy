//
//  NewPostViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 14/02/2022.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var continueToCategoryButton: UIButton!
    
    @IBOutlet weak var chooseCategoryLabel: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var continueToNextPageButton: UIButton!
    
    //MARK: - Properties
    let categoryCellId = "categoryCell"
    let segueIdToDescription = "newPostTitleToDescription"
    
    let categories = Jobs.arrayOfJobs
    
    var newPost: Post?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseCategoryLabel.isHidden = true
        categoriesTableView.isHidden = true
        continueToCategoryButton.isEnabled = false
        continueToNextPageButton.isHidden = true
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        guard let user = Auth.auth().currentUser else { return }
        
        newPost = Post(title: "", category: "", locality: "", postalCode: "", postDate: Date(), proUid: user.uid, description: "", imageUrl: "", isOnline: false)
    }
    
    //MARK: - Actions
    @IBAction func titleTextFieldEditingChanged(_ sender: UITextField) {
        guard let title = sender.text else { return }
        title.isTitleCorrectLenght ? (continueToCategoryButton.isEnabled = true) : (continueToCategoryButton.isEnabled = false)
    }
    
    
    @IBAction func continueToCategoryDidTouch(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        newPost?.title = title
        
        titleTextField.resignFirstResponder()
        titleTextField.isUserInteractionEnabled = false
        continueToCategoryButton.isHidden = true
        
        chooseCategoryLabel.isHidden = false
        categoriesTableView.isHidden = false
        continueToNextPageButton.isHidden = false
        continueToNextPageButton.isEnabled = false
    }
    
    @IBAction func continueToNextPageDidTouch(_ sender: Any) {
        performSegue(withIdentifier: segueIdToDescription, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToDescription {
            let destinationVC = segue.destination as! NewPostDescriptionViewController
            destinationVC.newPost = newPost
        }
    }
}

//MARK: - Extensions
extension NewPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellId, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = categories[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
}

extension NewPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        newPost?.category = categories[indexPath.row]
        continueToNextPageButton.isEnabled = true
    }
}
