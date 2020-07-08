//
//  CLPlaceMark_Ext.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import CoreLocation

extension CLPlacemark {
    var completeAddress: String? {
        if let name = self.name {
            var address = name
            
//            if let street = self.thoroughfare  {
//                address += ", \(street)"
//            }
            if let locality = self.locality  {
                address += ", \(locality)"
            }
            if let subLocality = self.administrativeArea  {
                address += ", \(subLocality)"
            }
            if let postalCode = self.postalCode  {
                address += ", \(postalCode)"
            }
            if let country = self.country  {
                address += ", \(country)"
            }
            return address
        }
        return nil
    }
}
