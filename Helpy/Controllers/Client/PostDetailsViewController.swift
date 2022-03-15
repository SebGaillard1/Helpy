//
//  PostDetailsViewController.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 28/02/2022.
//

import UIKit
import MapKit

class PostDetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postCityAndPostalCodeLabel: UILabel!
    @IBOutlet weak var postPostedByLabel: UILabel!
    @IBOutlet weak var postMKMapView: MKMapView!
    @IBOutlet weak var bottomContainerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: - Properties
    var post: Post!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
        
        postMKMapView.delegate = self
        let location = CLLocation(latitude: post.latitude, longitude: post.longitude)
        centerMapOnLocation(location, mapView: postMKMapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupUi() {
        postImageView.image = post.image
        postTitleLabel.text = post.title
        postCategoryLabel.text = post.category
        postDescriptionLabel.text = post.description
        postCityAndPostalCodeLabel.text = "\(post.locality) \(post.postalCode)"
        postPostedByLabel.text = "Par \(post.postedBy)" // A remplacer par le nom du pro
        postDateLabel.text = "Posté le \(post.postDate)"
        
        if let superview = postDescriptionLabel.superview {
            superview.addSeparator(x: 0, y: superview.bounds.minY - CGFloat(20))
            superview.addSeparator(x: 0, y: superview.bounds.maxY + CGFloat(20))
        }
        view.addGradientOnButtonTop(buttonContainerView: bottomContainerView)
    }
    
    // Radius is measured in meters
    private func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        mapView.isUserInteractionEnabled = false
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let location2d = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        addCircleOnMap(coordinate: location2d, radius: 1000)
    }
    
    // Radius is measured in meters
    private func addCircleOnMap(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate, radius: radius)
        postMKMapView.addOverlay(circle)
    }
}

//MARK: - Extension
extension PostDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleOverlay = overlay
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = .systemBlue
        circleRenderer.alpha = 0.40
        
        return circleRenderer
    }
}

