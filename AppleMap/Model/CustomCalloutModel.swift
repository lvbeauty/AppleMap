//
//  ViewModel.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class CustomCalloutModel: CalloutViewModel {
    var title: String
    var subtitle: String
    var image: UIImage
    
    init(title: String, subtitle: String, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
