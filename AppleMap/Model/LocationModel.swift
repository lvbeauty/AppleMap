//
//  LocationModel.swift
//  AppleMap
//
//  Created by Tong Yi on 7/7/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationModel: Decodable {
    var creator: String?
    var locat: String?
    var latitude: String?
    var longitude: String?
    
    var location: CLLocation = CLLocation()
    var address: String = String()
    
    init(location: CLLocation, address: String) {
        self.location = location
        self.address = address
    }
    
    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case locat = "location"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
