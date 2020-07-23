
//
//  CustomAnnotationVieew.swift
//  AppleMap
//
//  Created by Tong Yi on 7/2/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    var calloutView: CustomCalloutView?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.image = #imageLiteral(resourceName: "basic_annotation_image")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected {
            return;
        }
        
        guard let annotation = self.annotation as? CustomAnnotation else { return }
        
        if selected {
            if calloutView == nil {
                calloutView = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)?.first as? CustomCalloutView
            }
            
            calloutView!.center = CGPoint.init(x: bounds.width/2 + calloutOffset.x, y: -calloutView!.bounds.height/2 + calloutOffset.y)
            calloutView?.configureCallout(annotation.viewModel)
            
            addSubview(calloutView!)
        } else {
            calloutView!.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var view = super.hitTest(point, with: event)
         
        if view == nil {
            
            if self.calloutView == nil {
                return view
            }
            
            let temPoint1: CGPoint = (self.calloutView?.coordinateButton.convert(point, from: self))!
            let temPoint2: CGPoint = (self.calloutView?.addressButton.convert(point, from: self))!
            
            if (self.calloutView?.coordinateButton.bounds.contains(temPoint1))! {
                view = self.calloutView!.coordinateButton
            }
            
            if (self.calloutView?.addressButton.bounds.contains(temPoint2))! {
                view = self.calloutView!.addressButton
            }
        }
        
        return view
    }
}
