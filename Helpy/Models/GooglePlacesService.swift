//
//  GooglePlacesService.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 03/03/2022.
//

import Foundation

class GooglePlacesService {
    //MARK: - Singleton Pattern
    static let shared = GooglePlacesService()
    private init() {}
    
    //MARK: - Properties
    private let apiKey = ApiKeys.googlePlacesApiKey
    private let apiBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
    
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    //MARK: - Initializer
    init(session: URLSession) {
        self.session = session
    }

    func getPostalCodeAndLocality(fromLatitude latitude: String, fromLongitude longitude: String, completion: @escaping (_ success: Bool, _ locality: String, _ postalCode: String) -> Void) {
        let coordinates = "\(latitude),\(longitude)"
        let request = URLRequest(url: URL(string: "\(apiBaseUrl)?latlng=\(coordinates)&key=\(apiKey)")!)

        task?.cancel()
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(false, "", "")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(false, "", "")
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(Welcome.self, from: data) else {
                    completion(false, "", "")
                    return
                }
                
                var postalCode: String?
                var locality: String?
                for result in responseJSON.results[0].addressComponents {
                    if result.types[0] == "locality" {
                        locality = result.shortName
                    }
                    if result.types[0] == "postal_code" {
                        postalCode = result.shortName
                    }
                }
                guard let postalCode = postalCode, let locality = locality else {
                    completion(false, "", "")
                    return
                }

                completion(true, locality, postalCode)
            }
        })
        
        task?.resume()
    }
}
