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
            setLocationLabelText()
        }
    }
    var locality: String? {
        didSet {
            setLocationLabelText()
        }
    }
    var radiusInKm: Int? {
        didSet {
            delegate.send(radiusInKm: CLLocationDistance(radiusInKm ?? 1))
        }
    }
    
    var delegate: PostSearchLocationViewControllerDelegate!
    private let locationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        locationManager.delegate = self

        presentPlacesAutocompleteSearchController()
        
        locationLabel.layer.borderColor = UIColor.label.cgColor
        locationLabel.layer.borderWidth = 2.0
        locationLabel.layer.cornerRadius = 8
        setLocationLabelText()
        
        radiusLabel.text = "\(radiusInKm ?? 1) km"
    }
    
    private func setLocationLabelText() {
        if postalCode != nil && locality != nil {
            locationLabel.isHidden = false
            locationLabel.text = "   \(locality!) \(postalCode!)   "
        }
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
        radiusInKm = Int(sender.value)
        radiusLabel.text = "\(radiusInKm ?? 1) km"
    }
    
    @IBAction func validLocationDidTouch(_ sender: Any) {
        if postalCode != nil && locality != nil {
            delegate.send(locality: locality!, postalCode: postalCode!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func getCurrentLocationDidTouch(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}

//MARK: - Extensions
// Handle the user's selection.
extension PostSearchLocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        GooglePlacesService.shared.getPostalCodeAndLocality(fromLatitude: String(place.coordinate.latitude), fromLongitude: String(place.coordinate.longitude)) { success, locality, postalCode in
            if success && !locality.isEmpty && !postalCode.isEmpty {
                self.locality = locality
                self.postalCode = postalCode
                self.delegate.send(center: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
            } else {
                self.locality = nil
                self.postalCode = nil
            }
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
}

extension PostSearchLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            GooglePlacesService.shared.getPostalCodeAndLocality(fromLatitude: String(latitude), fromLongitude: String(longitude)) { success, locality, postalCode in
                if success {
                    self.locality = locality
                    self.postalCode = postalCode
                    self.delegate.send(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                } else {
                    self.locality = nil
                    self.postalCode = nil
                    // Gerer localisation impossible
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error with your location: \(error)")
    }
}

//MARK: - Protocol
protocol PostSearchLocationViewControllerDelegate {
    func send(center: CLLocationCoordinate2D)
    func send(radiusInKm: CLLocationDistance)
    func send(locality: String, postalCode: String)
    func enableSearchButton()
}




