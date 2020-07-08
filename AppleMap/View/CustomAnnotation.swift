//
//  CustomAnnotation.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var viewModel: CalloutViewModel
    var coordinate: CLLocationCoordinate2D
    
    init(viewModel: CalloutViewModel, coordinate: CLLocationCoordinate2D) {
        self.viewModel = viewModel
        self.coordinate = coordinate
    }
}
