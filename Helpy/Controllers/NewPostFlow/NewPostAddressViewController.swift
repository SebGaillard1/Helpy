//
//  NewPostAddressViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 15/02/2022.
//

import UIKit
import GooglePlaces

class NewPostAddressViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var localityTitleLabel: UILabel!
    @IBOutlet weak var localityNameLabel: UILabel!
    @IBOutlet weak var postalCodeTitleLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet var localityAndPostalCodeLabels: [UILabel]!
    
    @IBOutlet weak var addressSearchBar: UISearchBar!
    @IBOutlet weak var continueToNextPageButton: UIButton!
    
    //MARK: - Properties
    var newPost: Post!
    
    let segueIdToPhoto = "newPostAddressToPhoto"
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressSearchBar.delegate = self
        
        for label in localityAndPostalCodeLabels {
            label.isHidden = true
        }
        //continueToNextPageButton.isEnabled = false
        
        // REMOVE THAT !!!!!
        newPost.postalCode = "69002"
        newPost.locality = "Lyon"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdToPhoto {
            let destinationVC = segue.destination as! NewPostPhotoViewController
            destinationVC.newPost = newPost
        }
    }
    
    //MARK: - Actions
    @IBAction func continueToNextPageDidTouch(_ sender: Any) {
        performSegue(withIdentifier: segueIdToPhoto, sender: self)
    }
    
    private func presentGooglePlacesAddressViewController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify a filter
        let filter = GMSAutocompleteFilter()
        filter.country = "FR"
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Place data to return
        let fields: GMSPlaceField = [.formattedAddress, .addressComponents, .coordinate]
        autocompleteController.placeFields = fields

        present(autocompleteController, animated: true, completion: nil)
    }
}

//MARK: - Extensions
extension NewPostAddressViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presentGooglePlacesAddressViewController()
    }
}


extension NewPostAddressViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let components = place.addressComponents else { return }
        for component in components {
            for type in component.types {
                switch type {
                case "locality":
                    newPost.locality = component.name
                    localityNameLabel.text = component.name
                case "postal_code":
                    newPost.postalCode = component.name
                    postalCodeLabel.text = component.name
                    continueToNextPageButton.isEnabled = true
                default:
                    break
                }
            }
        }

        for label in localityAndPostalCodeLabels {
            label.isHidden = false
        }

        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
