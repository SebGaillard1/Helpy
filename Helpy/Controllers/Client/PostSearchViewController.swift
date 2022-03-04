//
//  PostSearchViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 03/03/2022.
//

import UIKit

class PostSearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    //MARK: - Properties
    private var categories = Categories.categoriesArray
    private var filteredCategories = [String]()
    
    private var radius = 0
    private var postalCode: String?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        searchBar.delegate = self
        
        categories = categories.map { $0.lowercased() }
        filteredCategories = categories
    }
}

//MARK: - Extensions
extension PostSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        var content = cell.defaultContentConfiguration()
        content.text = filteredCategories[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
}

extension PostSearchViewController: UITableViewDelegate {
    
}

extension PostSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCategories = categories.filter({ $0.contains(searchText.lowercased()) })
        filteredCategories = filteredCategories.map { $0.capitalized }
        categoryTableView.reloadData()
    }
}