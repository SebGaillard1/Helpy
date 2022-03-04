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
    @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    var delegate: PostSearchLocationViewControllerDelegate!
    private let locationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var postalCode: String?
    var locality: String?
    var radiusInKm = 1 {
        didSet {
            delegate.send(radiusInKm: CLLocationDistance(radiusInKm))
        }
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        locationManager.delegate = self
        
        presentPlacesAutocompleteSearchController()
        setupUi()
    }
    
    private func setupUi() {
        locationLabel.layer.borderColor = UIColor.label.cgColor
        locationLabel.layer.borderWidth = 2.0
        locationLabel.layer.cornerRadius = 8
        view.addSeparator(x: 0, y: locationLabel.layer.position.y - CGFloat(30))
        view.addSeparator(x: 0, y: locationLabel.layer.position.y + CGFloat(30))
        setLocationLabelText()
        
        radiusLabel.text = "\(radiusInKm) km"
        distanceSlider.setValue(Float(radiusInKm), animated: true)
    }
    
    private func setLocationLabelText() {
        if postalCode != nil && locality != nil {
            locationLabel.isHidden = false
            locationLabel.text = "   \(locality!) \(postalCode!)   "
        }
    }
    
    private func errorMessageLocationManager() {
        let ac = UIAlertController(title: "Erreur", message: "Impossible d'utiliser votre localisation", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
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
        
        let subView = UIView(frame: CGRect(x: 0, y: 50, width: view.bounds.width, height: 45.0))
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
        radiusLabel.text = "\(radiusInKm) km"
    }
    
    @IBAction func validLocationDidTouch(_ sender: Any) {
        if postalCode != nil && locality != nil {
            delegate.send(locality: locality!, postalCode: postalCode!)
            self.dismiss(animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: nil, message: "Veuillez sélectionner une localisation", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    @IBAction func getCurrentLocationDidTouch(_ sender: UIButton) {
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            errorMessageLocationManager()
            return
        case .authorizedAlways, .authorized, .authorizedWhenInUse:
            locationManager.requestLocation()
            locationActivityIndicator.isHidden = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            errorMessageLocationManager()
            return
        }
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
                self.setLocationLabelText()
                self.delegate.send(center: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
            } else {
                self.locality = nil
                self.postalCode = nil
                let ac = UIAlertController(title: "Erreur", message: "Impossible d'utiliser cette localisation, veuillez sélectionner une autre localisation", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
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
            
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let placemarks = placemarks,
                      error == nil else {
                          self.errorMessageLocationManager()
                          self.locationActivityIndicator.isHidden = true
                          return
                      }
                guard let placemark = placemarks.first else {
                    self.errorMessageLocationManager()
                    self.locationActivityIndicator.isHidden = true
                    return
                }
                self.locality = placemark.locality
                self.postalCode = placemark.postalCode
                self.setLocationLabelText()
                self.delegate.send(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                self.locationActivityIndicator.isHidden = true
            }
        } else {
            errorMessageLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationActivityIndicator.isHidden = true
        errorMessageLocationManager()
    }
}

//MARK: - Protocol
protocol PostSearchLocationViewControllerDelegate {
    func send(center: CLLocationCoordinate2D)
    func send(radiusInKm: CLLocationDistance)
    func send(locality: String, postalCode: String)
    func enableSearchButton()
}




