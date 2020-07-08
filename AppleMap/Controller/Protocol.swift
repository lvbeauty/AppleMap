//
//  Protocol.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

protocol CustomCalloutViewModelDelegate: class {
    func detailbuttonTapped()
    func addressButtonTapped()
}

protocol CalloutViewModel{}

protocol CalloutViewPlus: class {
    func configureCallout(_ viewModel: CalloutViewModel)
}
