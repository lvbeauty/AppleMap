//
//  LocationModel.swift
//  AppleMap
//
//  Created by Tong Yi on 7/7/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

struct LocationModel: Decodable {
    var creator: String
    var location: String
    var imagefile: URL
    var latitude: String
    var longitude: String
}
