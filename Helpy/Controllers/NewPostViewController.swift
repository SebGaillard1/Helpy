//
//  NewPostViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 14/02/2022.
//

import UIKit

class NewPostViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var continueToCategoryButton: UIButton!
    
    @IBOutlet weak var chooseCategoryLabel: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    @IBOutlet weak var continueToNextPageButton: UIButton!
    
    //MARK: - Properties
    let categoryCellId = "categoryCell"
    
    let categories = Jobs.arrayOfJobs
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseCategoryLabel.isHidden = true
        categoriesTableView.isHidden = true
        continueToNextPageButton.isHidden = true
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
    }
    
    @IBAction func continueToCategoryDidTouch(_ sender: Any) {
        titleTextField.resignFirstResponder()
        continueToCategoryButton.isHidden = true
        
        chooseCategoryLabel.isHidden = false
        categoriesTableView.isHidden = false
        continueToNextPageButton.isHidden = false
        continueToNextPageButton.isEnabled = false
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
        continueToNextPageButton.isEnabled = true
    }
}
