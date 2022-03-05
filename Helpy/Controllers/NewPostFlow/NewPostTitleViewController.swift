//
//  NewPostViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 14/02/2022.
//

import UIKit
import Firebase

class NewPostTitleViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var continueToCategoryButton: UIButton!
    
    @IBOutlet weak var chooseCategoryLabel: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var continueToNextPageButton: UIButton!
    
    //MARK: - Properties
    let categoryCellId = "categoryCell"
    let segueIdToDescription = "newPostTitleToDescription"
    
    let categories = Categories.categoriesArray
    
    var newPost: Post?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.hideKeyboardOnTap()
        
        chooseCategoryLabel.isHidden = true
        categoriesTableView.isHidden = true
        continueToCategoryButton.isEnabled = false
        continueToNextPageButton.isHidden = true
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        titleTextField.delegate = self
        
        guard let user = Auth.auth().currentUser else { return }
        
        newPost = Post(title: "", category: "", locality: "", postalCode: "", latitude: 0, longitude: 0, geohash: "", proUid: user.uid, description: "", image: nil, imageUrl: "", isOnline: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
extension NewPostTitleViewController: UITableViewDataSource {
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

extension NewPostTitleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        newPost?.category = categories[indexPath.row]
        continueToNextPageButton.isEnabled = true
    }
}

extension NewPostTitleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
