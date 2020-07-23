//
//  Protocol.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation
import CoreLocation

protocol CustomCalloutViewModelDelegate: class {
    func coordinateButtonTapped(_ address: String?)
    func addressButtonTapped(title: String, _ coordinate: CLLocationCoordinate2D?)
}

protocol CalloutViewModel{}

protocol CalloutViewPlus: class {
    func configureCallout(_ viewModel: CalloutViewModel)
}
