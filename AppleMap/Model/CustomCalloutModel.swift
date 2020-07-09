//
//  ViewModel.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit
import CoreLocation

class CustomCalloutModel: CalloutViewModel {
    var title: String
    var subtitle: String
    var image: UIImage
    var coordinate: CLLocationCoordinate2D?
    var address: String?
    
    init(title: String, subtitle: String, image: UIImage, at coordinate: CLLocationCoordinate2D?, address: String?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.coordinate = coordinate
        self.address = address
    }
}
