//
//  PostSearchViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 03/03/2022.
//

import UIKit
import CoreLocation

class PostSearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    //MARK: - Properties
    private var categories = Categories.categoriesArray
    private var filteredCategories = [String]()
    private var selectedCategory = ""
    
    private var radiusInKm: CLLocationDistance?
    private var center: CLLocationCoordinate2D?
    
    private var locality: String?
    private var postalCode: String? {
        didSet {
            locationButton.setTitle("\(locality!) \(postalCode!) ~ \(Int(radiusInKm!)) km", for: .normal)
        }
    }
    
    private var postsSearchResult = [Post]()
    private let segueIdToSearchLocation = "segueSearchToSearchLocation"
    private let segueIdToSearchResult = "segueSearchToSearchResult"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        searchBar.delegate = self
        
        categories = categories.map { $0.lowercased() }
        filteredCategories = categories
    }
    
    //MARK: - Actions
    @IBAction func searchDidTouch(_ sender: Any) {
        guard let radiusInKm = radiusInKm, let center = center else {
            // Gerer erreur
            return
        }
        
        let radiusInMeters = CLLocationDistance(Int(radiusInKm) * 1000)
        FirebaseDatabaseManager.shared.getPostByLocation(category: selectedCategory, center: center, radiusInMeters: radiusInMeters) { posts in
            if !posts.isEmpty {
                self.postsSearchResult = posts
                self.performSegue(withIdentifier: self.segueIdToSearchResult, sender: self)
            } else {
                let ac = UIAlertController(title: "Pas de resultat", message: "Il n'y a aucun résultat pour votre recherche :(", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToSearchLocation {
            let destinationVC = segue.destination as! PostSearchLocationViewController
            destinationVC.delegate = self
            destinationVC.locality = self.locality
            destinationVC.postalCode = self.postalCode
            destinationVC.radiusInKm = (Int(radiusInKm ?? 5))
        }
        if segue.identifier == segueIdToSearchResult {
            let destinationVC = segue.destination as! PostSearchResultViewController
            destinationVC.posts = postsSearchResult
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = filteredCategories[indexPath.row]
    }
}

extension PostSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCategories = categories.filter({ $0.contains(searchText.lowercased()) })
        filteredCategories = filteredCategories.map { $0.capitalized }
        categoryTableView.reloadData()
    }
}

extension PostSearchViewController: PostSearchLocationViewControllerDelegate {
    func send(locality: String, postalCode: String) {
        self.locality = locality
        self.postalCode = postalCode
    }
    
    func send(center: CLLocationCoordinate2D) {
        self.center = center
    }
    
    func send(radiusInKm: CLLocationDistance) {
        self.radiusInKm = radiusInKm
    }
    
    func enableSearchButton() {
        
    }
}

