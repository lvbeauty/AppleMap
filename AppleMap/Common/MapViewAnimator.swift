//
//  Animator.swift
//  AppleMap
//
//  Created by Tong Yi on 7/7/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

public enum CalloutViewShowingAnimationType {
    case fromTop, fromBottom, fromLeft, fromRight
}

public enum CalloutViewHidingAnimationType {
    case toTop, toBottom, toLeft, toRight
}

open class MapViewAnimator {
    
    var showingAnimationDuration: TimeInterval = 0.8
    var hidingAnimationDuration: TimeInterval = 0.15
    
    var animationValue: CGFloat = 30
    
    fileprivate(set) var defaultShowingAnimationType: CalloutViewShowingAnimationType = .fromBottom
    fileprivate(set) var defaultHidingAnimationType: CalloutViewHidingAnimationType = .toBottom
    
    func show(_ calloutView: UIView, andAnchorView anchorView: UIView, combinedView: CalloutAndAnchorView, withType animationType: CalloutViewShowingAnimationType, completion: (() -> ())? = nil) {
        
        calloutView.alpha = 0
        anchorView.alpha = 0
        
        let calloutFrameBeforeAnimation = calloutView.frame
        let anchorFrameBeforeAnimayion = anchorView.frame
        
        let addValueToY : CGFloat = animationType == .fromBottom ? animationValue : (animationType == .fromTop ? -animationValue : (0))
        let addValueToX : CGFloat = animationType == .fromRight ? animationValue : (animationType == .fromLeft ? -animationValue : (0))
        
        if animationType == .fromBottom || animationType == .fromTop {
            let transform = CGAffineTransform(scaleX: 0.4, y: 1.4)
            combinedView.transform = transform
        }else {
            let transform = CGAffineTransform(scaleX: 1.4, y: 0.4)
            combinedView.transform = transform
        }
        
        DispatchQueue.main.async {
            calloutView.frame.origin = CGPoint(x: calloutView.frame.origin.x + addValueToX, y: calloutView.frame.origin.y + addValueToY)
            anchorView.frame.origin = CGPoint(x: anchorView.frame.origin.x + addValueToX, y: anchorView.frame.origin.y + addValueToY)
            
            UIView.animate(withDuration: self.showingAnimationDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction, .curveEaseOut], animations: {
                
                calloutView.alpha = 1
                anchorView.alpha = 1
                
                calloutView.frame = calloutFrameBeforeAnimation
                anchorView.frame = anchorFrameBeforeAnimayion
                
                combinedView.transform = .identity
                
            }, completion: { completed in
                guard completed else { return }
                completion?()
            })
        }
    }
    
    func hide(_ combinedView: UIView, withAnimationType animationType: CalloutViewHidingAnimationType, completion: (() -> ())? = nil) {
        
        let addValueToY : CGFloat = animationType == .toBottom ? animationValue : (animationType == .toTop ? -animationValue : (0))
        let addValueToX : CGFloat = animationType == .toRight ? animationValue : (animationType == .toLeft ? -animationValue : (0))
        
        DispatchQueue.main.async {
    
            UIView.animate(withDuration: self.hidingAnimationDuration, animations: {
                
                combinedView.alpha = 0
                
                combinedView.frame.origin = CGPoint(x: combinedView.frame.origin.x + addValueToX, y: combinedView.frame.origin.y + addValueToY)
                
                if animationType == .toTop || animationType == .toBottom {
                    combinedView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                }else {
                    combinedView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                }
                
            }, completion: { completed in
                
                guard completed else { return }
                combinedView.removeFromSuperview()
                completion?()
            })
        }
    }
}

