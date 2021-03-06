//
//  Constants.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 12/02/2022.
//

import Foundation
import Firebase
import UIKit

struct Constants {
    static let appAccentUIColor = UIColor(red: 140/255, green: 82/255, blue: 255/255, alpha: 1)
    
    struct StoryBoard {
        static let clientHomeViewController = "ClientHomeVC"
    }
    
    struct FirebaseHelper {
        static let pathForClients = "clients"
        static let pathForPros = "professionals"
        static let pathForPosts = "posts"
        
        static let clientRef = Firestore.firestore().collection(pathForClients)
        static let proRef = Firestore.firestore().collection(pathForPros)
        
        static let realtimeDbUrl = "https://helpy-f4c5d-default-rtdb.europe-west1.firebasedatabase.app/"
    }
    
    struct SegueId {
        static let conversationsToChat = "conversationsToChat"
        static let postDetailsToChat = "postDetailsToChat"
        static let clientHomeToPostDetails = "homeToPostDetails"
        static let clientHomeToSearch = "clientHomeToSearch"
        
        static let proHomeToPostDetails = "proHomeToPostDetails"
        static let proHomepageToChat = "proHomepageToChat"
    }
}




