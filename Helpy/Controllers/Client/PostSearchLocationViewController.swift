//
//  PostSearchLocationViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 03/03/2022.
//

import UIKit
import GooglePlaces

class PostSearchLocationViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    //MARK: - Properties
    var postalCode: String? {
        didSet {
            if postalCode != nil && city != nil {
                locationLabel.text = "\(city!) \(postalCode!)"
            }
        }
    }
    var city: String? {
        didSet {
            if postalCode != nil && city != nil {
                locationLabel.text = "\(city!) \(postalCode!)"
            }
        }
    }
    var radius = 0 {
        didSet {
            radiusLabel.text = "\(radius) km"
        }
    }
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        presentPlacesAutocompleteSearchController()
    }
    
    private func presentPlacesAutocompleteSearchController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        // Specify a filter
        let filter = GMSAutocompleteFilter()
        filter.country = "FR"
        filter.type = .city
        resultsViewController?.autocompleteFilter = filter
        
        // Place data to return
        let fields: GMSPlaceField = [.formattedAddress, .addressComponents, .coordinate]
        resultsViewController?.placeFields = fields
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 30, width: view.bounds.width, height: 45.0))
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.searchBar.placeholder = "Saisissez une ville ou un code postal"
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    //MARK: - Actions
    @IBAction func distanceSliderDidChange(_ sender: UISlider) {
        radius = Int(sender.value)
    }
    
    @IBAction func validLocationDidTouch(_ sender: Any) {
    }
}

//MARK: - Extensions
// Handle the user's selection.
extension PostSearchLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        print(place.coordinate)
        GooglePlacesService.shared.getPostalCodeAndLocality(fromLatitude: String(place.coordinate.latitude), fromLongitude: String(place.coordinate.longitude)) { success, locality, postalCode in
            if success && !locality.isEmpty && !postalCode.isEmpty {
                self.city = locality
                self.postalCode = postalCode
            } else {
                self.city = nil
                self.postalCode = nil
            }
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
}

