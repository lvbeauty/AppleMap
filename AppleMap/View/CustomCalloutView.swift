//
//  CustomCalloutView.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var coordinateButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    
    var delegate: CustomCalloutViewModelDelegate?
    
    @IBAction func coordinateButtonTapped(_ sender: UIButton) {
        delegate?.detailbuttonTapped()
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        delegate?.addressButtonTapped()
    }
    
    deinit {
        print("deallocated")
    }
}

extension CustomCalloutView: CalloutViewPlus {
    func configureCallout(_ viewModel: CalloutViewModel) {
        guard let viewModel = viewModel as? CustomCalloutModel else { return }
        
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        myImageView.image = viewModel.image
    }
}
