//
//  FirebaseRealtimeDatabaseManager.swift
//  Helpy
//
//  Created by Sebastien Gaillard on 06/03/2022.
//

import Foundation
import FirebaseDatabase

final class FirebaseRealtimeDatabaseManager {
    static let shared = FirebaseRealtimeDatabaseManager()
    
    private let db = Database.database(url: Constants.FirebaseHelper.realtimeDbUrl).reference()
    
    public func test() {
        db.child("test").setValue(["somthing": true])
    }
}
